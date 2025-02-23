import 'package:chatapp/features/chat/data/dto/chat_dto.dart';
import 'package:chatapp/features/users/domain/user_repository_interface.dart';

abstract interface class ChatRepositoryInterface {
  Stream<List<ChatDTO>?> getChats();
  Future<String?> getPrivateChatIdByFriendId(String friendId);
  Stream<int> getUnseenMessagesCount(String chatId);
  Stream<List<MessageDTO>?> getMessages(String chatId);
  Future<MessageDTO?> sendMessage(String chatId, String message);
  Future<void> markMessageAsSeen(String chatId, String messageId);
  Future<void> createPrivateChat(String friendId);
  Future<void> createGroupChat(
      String groupName, String groupPhotoURL, List<String> participants);
  Future<void> deleteChat(String chatId);
  Future<String?> getChatPhotoURL(
      ChatDTO chat, UserRepositoryInterface userRepo);
}
