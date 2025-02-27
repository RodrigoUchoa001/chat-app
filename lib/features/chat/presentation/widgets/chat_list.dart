import 'package:chatapp/core/providers/firebase_auth_providers.dart';
import 'package:chatapp/features/chat/data/dto/chat_dto.dart';
import 'package:chatapp/features/chat/data/repositories/chat_repository.dart';
import 'package:chatapp/features/chat/domain/repositories/chat_repository_interface.dart';
import 'package:chatapp/features/chat/presentation/utils/calculate_time_since_last_message.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_profile_pic.dart';
import 'package:chatapp/features/users/data/repositories/user_repository.dart';
import 'package:chatapp/features/users/domain/user_repository_interface.dart';
import 'package:chatapp/gen/fonts.gen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChatList extends ConsumerWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatRepositoryProvider);
    final user = ref.watch(currentUserProvider).asData?.value;
    final userProvider = ref.watch(userRepositoryProvider);
    final unseenMessagesCount = ref.watch(unreadMessagesProvider(user!.uid));

    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 26),
      child: StreamBuilder(
        stream: chats.getChats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red)));
          }

          final data = snapshot.data;
          if (data!.isEmpty) {
            return Center(
              child: const Text(
                'No chats yet!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: FontFamily.circular,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final chat = data[index];

              return TextButton(
                onPressed: () {
                  context.push('/chat/${chat.id}');
                },
                child: chatButton(
                    chats, chat, userProvider, user, unseenMessagesCount),
              );
            },
          );
        },
      ),
    );
  }

  Widget chatButton(
      ChatRepositoryInterface chats,
      ChatDTO chat,
      UserRepositoryInterface userProvider,
      User user,
      AsyncValue<int> unseenMessagesCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
            future: chats.getChatPhotoURL(chat, userProvider),
            builder: (context, snapshot) {
              final chatPhoto = snapshot.data;
              final hasValidPhoto = chatPhoto != null && chatPhoto.isNotEmpty;

              return ChatProfilePic(
                chatPhotoURL: hasValidPhoto ? chatPhoto : null,
                isOnline: true,
              );
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                    future: _getChatTitle(chat, user.uid, userProvider),
                    builder: (context, snapshot) {
                      final chatTitle = snapshot.data;
                      return Text(
                        chatTitle ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: FontFamily.caros,
                        ),
                      );
                    }),
                const SizedBox(height: 6),
                Text(
                  chat.lastMessage != null ? chat.lastMessage!.text ?? '' : '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: Color(0xFF797C7B),
                    fontSize: 12,
                    fontFamily: FontFamily.circular,
                  ),
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                chat.lastMessage != null
                    ? calculateTimeSinceLastMessage(
                        chat.lastMessage!.timestamp!)
                    : "",
                style: TextStyle(
                  color: Color(0xFF797C7B),
                  fontSize: 12,
                  fontFamily: FontFamily.circular,
                ),
              ),
              const SizedBox(height: 7),
              unseenMessagesCount.when(
                data: (count) {
                  return count == 0
                      ? Container()
                      : Container(
                          width: 21.81,
                          height: 21.81,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Color(0xFFF04A4C),
                          ),
                          child: Center(
                            child: Text(
                              count.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: FontFamily.circular,
                              ),
                            ),
                          ),
                        );
                },
                error: (error, stackTrace) => SizedBox(),
                loading: () => SizedBox(),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<String> _getChatTitle(
      ChatDTO chat, String userId, UserRepositoryInterface userRepo) async {
    if (chat.type == 'group') {
      return chat.groupName ?? 'No group name';
    } else {
      final friendId =
          chat.participants!.firstWhere((id) => id != userId, orElse: () => '');

      if (friendId.isNotEmpty) {
        final friend = await userRepo.getUserDetails(friendId).first;
        return friend?.name ?? 'No friend name';
      }
      return '';
    }
  }
}
