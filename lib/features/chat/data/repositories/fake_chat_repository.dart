import 'package:chatapp/features/chat/data/dto/chat_dto.dart';
import 'package:chatapp/features/chat/domain/repositories/chat_repository_interface.dart';
import 'package:chatapp/features/users/domain/user_repository_interface.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fakeChatRepositoryProvider = Provider((ref) => FakeChatRepository());

final mockUserChatsProvider = StreamProvider<List<ChatDTO>?>((ref) {
  final chatRepo = ref.watch(fakeChatRepositoryProvider);
  return chatRepo.getChats();
});

final fakeUnreadMessagesProvider =
    StreamProvider.family<int, String>((ref, chatId) {
  final chatRepo = ref.watch(fakeChatRepositoryProvider);
  return chatRepo.getUnseenMessagesCount(chatId);
});

class FakeChatRepository implements ChatRepositoryInterface {
  final String _userId = "user1";

  @override
  Future<String> createGroupChat(
      {required String groupName,
      required String groupPhotoURL,
      required List<String> participants}) {
    // TODO: implement createGroupChat
    throw UnimplementedError();
  }

  @override
  Future<void> createPrivateChat(String friendId) {
    // TODO: implement createPrivateChat
    throw UnimplementedError();
  }

  @override
  Future<void> deleteChat(String chatId) {
    // TODO: implement deleteChat
    throw UnimplementedError();
  }

  @override
  Stream<List<ChatDTO>?> getChats() async* {
    await Future.delayed(Duration(seconds: 1)); // Simula tempo de resposta
    yield [
      ChatDTO(
        type: "group",
        groupName: "Grupo 1",
        groupPhotoURL:
            "https://www.riobranco.rs.gov.br/wp-content/uploads/2019/08/Logo-Rio-Branco-500x500.png",
        admins: ["user1", "user2"],
        participants: ["user1", "user2", "user3", "user4"],
        lastMessage: MessageDTO(
          senderId: "user1",
          text: "Olá, tudo bem?",
          timestamp: "2025-01-02 09:45:10",
        ),
        createdAt: "2025-01-02 23:00:40",
      ),
      ChatDTO(
        type: "private",
        groupName: "Fulano de tal",
        groupPhotoURL: null,
        admins: ["user1", "user2"],
        participants: ["user1", "user2"],
        lastMessage: MessageDTO(
          senderId: "user2",
          text: "Olá, tudo bem?",
          timestamp: "2025-02-17 09:45:10",
        ),
        createdAt: "2025-31-01 23:00:40",
      ),
    ];
  }

  @override
  Stream<List<MessageDTO>?> getMessages(String chatId) {
    // TODO: implement getMessages
    throw UnimplementedError();
  }

  @override
  Future<void> markMessageAsSeen(String chatId, String messageId) {
    // TODO: implement markMessageAsSeen
    throw UnimplementedError();
  }

  @override
  Future<MessageDTO?> sendMessage(String chatId, String message) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }

  @override
  Stream<int> getUnseenMessagesCount(String chatId) async* {
    await Future.delayed(Duration(seconds: 1));
    yield _userId == "user1" ? 5 : 0;
  }

  @override
  Future<String?> getPrivateChatIdByFriendId(String friendId) {
    // TODO: implement getPrivateChatIdByFriendId
    throw UnimplementedError();
  }

  @override
  Future<String?> getChatPhotoURL(
      ChatDTO chat, UserRepositoryInterface userRepo) {
    // TODO: implement getChatPhotoURL
    throw UnimplementedError();
  }

  @override
  Stream<ChatDTO?> getChatDetails(String chatId) {
    // TODO: implement getChatDetails
    throw UnimplementedError();
  }

  @override
  Stream<List<ChatDTO>> searchChats(String query) {
    // TODO: implement searchChats
    throw UnimplementedError();
  }

  @override
  Stream<int> getNumberOfOnlineMembers(String chatId) {
    // TODO: implement getNumberOfOnlineMembers
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAllPrivateChats() {
    // TODO: implement deleteAllPrivateChats
    throw UnimplementedError();
  }

  @override
  Future<void> leftAllGroupChats() {
    // TODO: implement leftAllGroupChats
    throw UnimplementedError();
  }
}
