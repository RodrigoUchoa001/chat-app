import 'package:chatapp/features/chat/data/dto/chat_dto.dart';
import 'package:chatapp/features/chat/domain/repositories/chat_repository_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository implements ChatRepositoryInterface {
  final FirebaseFirestore _firestore;
  final String _userId;

  ChatRepository(this._firestore, this._userId);

  @override
  Stream<List<ChatDTO>?> getChats() {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: _userId)
        .snapshots()
        .map((querySnapshot) {
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
  Future<MessageDTO?> sendMessage(String chatId, String message) {
    final messageRef = _firestore.collection('messages').doc(chatId);

    return messageRef.collection('messages').add({
      'senderId': _userId,
      'text': message,
      'timestamp': FieldValue.serverTimestamp(),
    }).then((doc) {
      return MessageDTO(
        senderId: doc.id,
        text: message,
        timestamp: DateTime.now().toString(),
      );
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
}
