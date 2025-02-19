import 'package:chatapp/core/providers/firebase_auth_providers.dart';
import 'package:chatapp/core/providers/firebase_firestore_provider.dart';
import 'package:chatapp/features/chat/data/dto/chat_dto.dart';
import 'package:chatapp/features/chat/domain/repositories/chat_repository_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRepositoryProvider = Provider<ChatRepositoryInterface>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final currentUser = ref.watch(currentUserProvider).asData?.value;

  return ChatRepository(firestore, currentUser!.uid);
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
        .snapshots()
        .map((querySnapshot) {
      if (querySnapshot.docs.isEmpty) return [];
      return querySnapshot.docs.map((doc) {
        return ChatDTO.fromJson(doc.data());
      }).toList();
    });
  }

  @override
  Stream<List<MessageDTO>?> getMessages(String chatId) {
    return _firestore
        .collection('messages')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return MessageDTO.fromJson(doc.data());
      }).toList();
    });
  }

  @override
  Future<MessageDTO?> sendMessage(
    String chatId,
    String message, {
    String? friendId,
    List<String>? groupParticipants,
    String? groupName,
    String? groupPhotoURL,
  }) async {
    final chatRef = _firestore.collection('chats').doc(chatId);
    final messageRef = _firestore.collection('messages').doc(chatId);

    final chatDoc = await chatRef.get();
    // if chat doesn't exist, create it
    if (!chatDoc.exists) {
      if (friendId != null) {
        await createPrivateChat(friendId);
      } else if (groupParticipants != null && groupName != null) {
        await createGroupChat(
            groupName, groupPhotoURL ?? '', groupParticipants);
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
      'createdAt': FieldValue.serverTimestamp(),
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
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> deleteChat(String chatId) {
    return _firestore.collection('chats').doc(chatId).delete();
  }

  @override
  Stream<int> getUnseenMessagesCount(String chatId) {
    return _firestore
        .collection('messages')
        .doc(chatId)
        .collection('messages')
        .where('seenBy', arrayContains: _userId, isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
