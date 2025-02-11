import 'package:chatapp/features/chat/data/dto/chat_dto.dart';

abstract interface class ChatRepositoryInterface {
  Stream<List<ChatDTO>?> getChats();
  Stream<List<MessageDTO>?> getMessages(String chatId);
  Future<MessageDTO?> sendMessage(String chatId, String message);
  Future<void> markMessageAsSeen(String chatId, String messageId);
  Future<void> createPrivateChat(String friendId);
  Future<void> createGroupChat(
      String groupName, String groupPhotoURL, List<String> participants);
  Future<void> deleteChat(String chatId);
}
