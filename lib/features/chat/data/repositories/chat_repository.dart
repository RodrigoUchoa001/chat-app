import 'package:chatapp/core/providers/firebase_auth_providers.dart';
import 'package:chatapp/core/providers/firebase_firestore_provider.dart';
import 'package:chatapp/features/chat/data/dto/chat_dto.dart';
import 'package:chatapp/features/chat/domain/repositories/chat_repository_interface.dart';
import 'package:chatapp/features/users/domain/user_repository_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRepositoryProvider = Provider<ChatRepositoryInterface>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final currentUser = ref.watch(currentUserProvider).asData?.value;

  if (currentUser == null) {
    throw Exception('User is null on chatRepositoryProvider');
  }

  return ChatRepository(firestore, currentUser.uid);
});

final unreadMessagesProvider =
    StreamProvider.family<int, String>((ref, chatId) {
  final chatRepo = ref.watch(chatRepositoryProvider);
  return chatRepo.getUnseenMessagesCount(chatId);
});

class ChatRepository implements ChatRepositoryInterface {
  final FirebaseFirestore _firestore;
  final String _userId;

  ChatRepository(this._firestore, this._userId);

  @override
  Stream<List<ChatDTO>> getChats() {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: _userId)
        .where('lastMessage', isNull: false)
        .orderBy('lastMessage.timestamp', descending: true)
        .snapshots()
        .map((querySnapshot) {
      if (querySnapshot.docs.isEmpty) return [];
      return querySnapshot.docs.map((doc) {
        return ChatDTO.fromJson(doc.data()).copyWith(id: doc.id);
      }).toList();
    });
  }

  @override
  Future<String?> getPrivateChatIdByFriendId(String friendId) async {
    final querySnapshot = await _firestore
        .collection('chats')
        .where('type', isEqualTo: "private")
        .where('participants', arrayContains: _userId)
        .get();

    for (var doc in querySnapshot.docs) {
      List<dynamic> participants = doc['participants'];
      if (participants.contains(friendId)) {
        return doc.id;
      }
    }

    return null;
  }

  @override
  Stream<List<MessageDTO>?> getMessages(String chatId) {
    return _firestore
        .collection('messages')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        // mark all the messages as seen
        markMessageAsSeen(chatId, doc.id);

        return MessageDTO.fromJson(doc.data());
      }).toList();
    });
  }

  @override
  Future<MessageDTO?> sendMessage(
    String chatId,
    String message, {
    String? friendId,
  }) async {
    final chatRef = _firestore.collection('chats').doc(chatId);
    final messageRef = _firestore.collection('messages').doc(chatId);

    final chatDoc = await chatRef.get();
    // if chat doesn't exist, create it
    if (!chatDoc.exists) {
      // the chat can not exist only if it's a private chat
      if (friendId != null) {
        await createPrivateChat(friendId);
      } else {
        throw Exception("Não foi possível determinar o tipo de chat.");
      }
    }

    return messageRef
        .collection('messages')
        .add(
          MessageDTO(
            senderId: _userId,
            text: message,
            timestamp: DateTime.now().toString(),
            seenBy: [],
          ).toJson(),
        )
        .then((doc) {
      // updating last message in chat doc
      final chatRef = _firestore.collection('chats').doc(chatId);
      chatRef.update({
        'lastMessage': MessageDTO(
          senderId: _userId,
          text: message,
          timestamp: DateTime.now().toString(),
        ).toJson()
      });

      return MessageDTO(
        senderId: doc.id,
        text: message,
        timestamp: DateTime.now().toString(),
      );
    });
  }

  @override
  Future<void> markMessageAsSeen(String chatId, String messageId) {
    return _firestore
        .collection('messages')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({
      'seenBy': FieldValue.arrayUnion([_userId])
    });
  }

  @override
  Future<void> createPrivateChat(String friendId) {
    return _firestore.collection('chats').add({
      'type': "private",
      'participants': [_userId, friendId],
      'createdAt': DateTime.now().toString(),
      'lastMessage': null,
    });
  }

  @override
  Future<void> createGroupChat(
      String groupName, String groupPhotoURL, List<String> participants) {
    return _firestore.collection('chats').add({
      'type': "group",
      'groupName': groupName,
      'groupPhotoURL': groupPhotoURL,
      'admins': [_userId],
      'participants': participants,
      'createdAt': DateTime.now().toString(),
      'lastMessage': null,
    });
  }

  @override
  Future<void> deleteChat(String chatId) {
    return _firestore.collection('chats').doc(chatId).delete();
  }

  @override
  Stream<int> getUnseenMessagesCount(String chatId) {
    final totalMessagesStream = _firestore
        .collection('messages')
        .doc(chatId)
        .collection('messages')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.length);

    final seenMessagesStream = _firestore
        .collection('messages')
        .doc(chatId)
        .collection('messages')
        .where('seenBy', arrayContains: _userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);

    return totalMessagesStream.asyncMap((totalCount) async {
      final seenCount = await seenMessagesStream.first;
      return totalCount - seenCount;
    });
  }

  @override
  Future<String?> getChatPhotoURL(
      ChatDTO chat, UserRepositoryInterface userRepo) async {
    if (chat.type == 'group') {
      return chat.groupPhotoURL ?? '';
    } else {
      final friendId = chat.participants!
          .firstWhere((id) => id != _userId, orElse: () => '');

      if (friendId.isNotEmpty) {
        final friend = await userRepo.getUserDetails(friendId).first;
        return friend?.photoURL ?? '';
      }
    }
    return '';
  }

  @override
  Stream<ChatDTO?> getChatDetails(String chatId) {
    return _firestore.collection('chats').doc(chatId).snapshots().map(
          (snapshot) => snapshot.data() != null
              ? ChatDTO.fromJson(snapshot.data()!)
              : null,
        );
  }

  @override
  Stream<List<ChatDTO>> searchChats(String query) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: _userId)
        .snapshots()
        .map((querySnapshot) {
      if (querySnapshot.docs.isEmpty) return [];
      return querySnapshot.docs
          .map((doc) => ChatDTO.fromJson(doc.data()).copyWith(id: doc.id))
          .where((chat) =>
              chat.type == 'group' &&
              (chat.groupName?.toLowerCase() ?? '')
                  .contains(query.toLowerCase()))
          .toList();
    });
  }
}
