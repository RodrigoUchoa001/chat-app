import 'package:chatapp/core/providers/firebase_auth_providers.dart';
import 'package:chatapp/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:chatapp/features/chat/data/dto/chat_dto.dart';
import 'package:chatapp/features/chat/data/repositories/chat_repository.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_input_field.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_profile_pic.dart';
import 'package:chatapp/features/users/data/repositories/user_repository.dart';
import 'package:chatapp/features/users/domain/user_repository_interface.dart';
import 'package:chatapp/gen/assets.gen.dart';
import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String chatId;
  const ChatScreen({required this.chatId, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final chatProvider = ref.watch(chatRepositoryProvider);
    final userRepo = ref.watch(userRepositoryProvider);
    final currentUser = ref.watch(currentUserProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF121414),
        appBar: AppBar(
          toolbarHeight: 124,
          backgroundColor: Colors.transparent,
          leading: AuthBackButton(),
          title: StreamBuilder(
            stream: chatProvider.getChatDetails(widget.chatId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final chat = snapshot.data!;
              return Row(
                children: [
                  FutureBuilder(
                    future: chatProvider.getChatPhotoURL(
                      chat,
                      userRepo,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      final chatPhoto = snapshot.data;
                      final hasValidPhoto =
                          chatPhoto != null && chatPhoto.isNotEmpty;

                      return ChatProfilePic(
                        chatPhotoURL: hasValidPhoto ? chatPhoto : null,
                        // TODO: If private chat, check if user is online
                        isOnline: chat.type == 'group' ? false : true,
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      currentUser.when(
                        data: (user) {
                          return FutureBuilder(
                            future: _getChatTitle(chat, user!.uid, userRepo),
                            builder: (context, snapshot) {
                              return Text(
                                snapshot.data ?? 'No title',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: FontFamily.caros,
                                ),
                              );
                            },
                          );
                        },
                        error: (error, stackTrace) => Text('Error: $error'),
                        loading: () => const CircularProgressIndicator(),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'online',
                        style: TextStyle(
                          color: Color(0xFF797C7B),
                          fontSize: 12,
                          fontFamily: FontFamily.circular,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            Row(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        Assets.icons.call.path,
                        height: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        Assets.icons.video.path,
                        height: 24,
                      ),
                    ),
                    const SizedBox(width: 24),
                  ],
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    chatBubble(
                      message: "Hello how are you?",
                      time: "09:25 AM",
                      isMe: true,
                    ),
                    chatBubble(
                      message: "Hello de boassa?",
                      time: "09:25 AM",
                      isMe: false,
                    ),
                  ],
                ),
              ),
            ),
            ChatInputField(),
          ],
        ),
      ),
    );
  }

  Widget chatBubble(
      {required String message, required String time, required bool isMe}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30, left: 24, right: 24),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              height: 36,
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFF20A090) : const Color(0xFF212727),
                borderRadius: BorderRadius.only(
                  topLeft: isMe ? Radius.circular(50) : Radius.zero,
                  topRight: isMe ? Radius.zero : Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: FontFamily.circular,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              time,
              style: const TextStyle(
                color: Color(0xFF797C7B),
                fontSize: 10,
                fontFamily: FontFamily.circular,
              ),
            ),
          ],
        ),
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
