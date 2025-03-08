import 'package:chatapp/core/providers/firebase_auth_providers.dart';
import 'package:chatapp/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:chatapp/features/chat/data/dto/chat_dto.dart';
import 'package:chatapp/features/chat/data/repositories/chat_repository.dart';
import 'package:chatapp/features/chat/domain/repositories/chat_repository_interface.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_input_field.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_profile_pic.dart';
import 'package:chatapp/features/users/data/repositories/user_repository.dart';
import 'package:chatapp/features/users/domain/user_repository_interface.dart';
import 'package:chatapp/gen/assets.gen.dart';
import 'package:chatapp/gen/fonts.gen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String chatId;
  const ChatScreen({required this.chatId, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = ref.watch(chatRepositoryProvider);
    final userRepo = ref.watch(userRepositoryProvider);
    final currentUser = ref.watch(currentUserProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF121414),
        appBar: chatAppBar(chatProvider, userRepo, currentUser),
        body: Column(
          children: [
            StreamBuilder(
              stream: chatProvider.getMessages(widget.chatId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                final messages = snapshot.data!;
                if (messages.isEmpty) {
                  return const Expanded(
                    child: Center(
                      child: Text(
                        'No messages yet!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: FontFamily.circular,
                        ),
                      ),
                    ),
                  );
                }

                // scroll to the end when a new message appears
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => _scrollToBottom());

                return messagesList(messages, currentUser, userRepo);
              },
            ),
            ChatInputField(chatId: widget.chatId),
          ],
        ),
      ),
    );
  }

  AppBar chatAppBar(ChatRepositoryInterface chatProvider,
      UserRepositoryInterface userRepo, AsyncValue<User?> currentUser) {
    return AppBar(
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

          if (chat.type == 'group') {
            return Row(
              children: [
                FutureBuilder(
                  future: chatProvider.getChatPhotoURL(
                    chat,
                    userRepo,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(
                          color: Colors.white);
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    final chatPhoto = snapshot.data;
                    final hasValidPhoto =
                        chatPhoto != null && chatPhoto.isNotEmpty;

                    return ChatProfilePic(
                      chatPhotoURL: hasValidPhoto ? chatPhoto : '',
                      isOnline: false,
                    );
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
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
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            },
                          );
                        },
                        error: (error, stackTrace) => Text('Error: $error'),
                        loading: () => const CircularProgressIndicator(),
                      ),
                      const SizedBox(height: 6),
                      StreamBuilder(
                        stream: chatProvider.getNumberOfOnlineMembers(
                          widget.chatId,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(
                                color: Colors.white);
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          final onlineMembers = snapshot.data ?? 0;
                          return Text(
                            '${chat.participants!.length} members ${onlineMembers > 0 ? ', $onlineMembers online' : ''}',
                            style: TextStyle(
                              color: Color(0xFF797C7B),
                              fontSize: 12,
                              fontFamily: FontFamily.circular,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
            // if it's a private chat
          } else {
            final friendId = chat.participants != null
                ? chat.participants!.firstWhere(
                    (id) => id != currentUser.value?.uid,
                    orElse: () => '',
                  )
                : '';

            final friendDetails = userRepo.getUserDetails(friendId);

            return Row(
              children: [
                FutureBuilder(
                  future: chatProvider.getChatPhotoURL(
                    chat,
                    userRepo,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(
                          color: Colors.white);
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    final chatPhoto = snapshot.data;
                    final hasValidPhoto =
                        chatPhoto != null && chatPhoto.isNotEmpty;

                    final friendId =
                        (chat.type == 'private' && chat.participants != null)
                            ? chat.participants!.firstWhere(
                                (id) => id != currentUser.value?.uid,
                                orElse: () => '',
                              )
                            : '';

                    final friendDetails = userRepo.getUserDetails(friendId);

                    return StreamBuilder(
                      stream: friendDetails,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(
                              color: Colors.white);
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        final friend = snapshot.data!;

                        return ChatProfilePic(
                          chatPhotoURL: hasValidPhoto ? chatPhoto : null,
                          isOnline: friend.isOnline!,
                        );
                      },
                    );
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
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
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            },
                          );
                        },
                        error: (error, stackTrace) => Text('Error: $error'),
                        loading: () => const CircularProgressIndicator(),
                      ),
                      const SizedBox(height: 6),
                      StreamBuilder(
                        stream: friendDetails,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                              'Checking...',
                              style: TextStyle(
                                color: Color(0xFF797C7B),
                                fontSize: 12,
                                fontFamily: FontFamily.circular,
                              ),
                            );
                          }
                          final friend = snapshot.data;
                          return Text(
                            friend!.isOnline ?? false
                                ? 'online'
                                : 'last seen at ${DateFormat('hh:mm a').format(DateTime.parse(friend.lastSeen!))}',
                            style: TextStyle(
                              color: Color(0xFF797C7B),
                              fontSize: 12,
                              fontFamily: FontFamily.circular,
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            );
          }
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
    );
  }

  Widget messagesList(List<MessageDTO> messages, AsyncValue<User?> currentUser,
      UserRepositoryInterface userRepo) {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          final isMe = message.senderId == currentUser.value?.uid;

          // Check if the next or previous message is from the same sender
          final bool isNextFromSameSender = index < messages.length - 1 &&
              messages[index + 1].senderId == message.senderId;
          final bool isPreviousFromSameSender =
              index > 0 && messages[index - 1].senderId == message.senderId;

          // Define a smaller padding if the next message is from the same user
          final double bottomPadding = isNextFromSameSender ? 5 : 30;

          // Check if the current message is the first message of the day
          final bool isFirstMessageOfTheDay = index == 0 ||
              DateTime.parse(messages[index - 1].timestamp!).day !=
                  DateTime.parse(messages[index].timestamp!).day;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isFirstMessageOfTheDay)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF1D2525),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Text(
                      messageDate(messages[index].timestamp!),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: FontFamily.circular,
                      ),
                    ),
                  ),
                ),
              chatBubble(bottomPadding, isMe, isNextFromSameSender,
                  isPreviousFromSameSender, message, userRepo),
            ],
          );
        },
      ),
    );
  }

  Widget chatBubble(
      double bottomPadding,
      bool isMe,
      bool isNextFromSameSender,
      bool isPreviousFromSameSender,
      MessageDTO message,
      UserRepositoryInterface userProvider) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding, left: 24, right: 24),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isPreviousFromSameSender && !isMe)
              StreamBuilder(
                stream: userProvider.getUserDetails(message.senderId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  final user = snapshot.data;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ChatProfilePic(
                        chatPhotoURL: user!.photoURL,
                        isOnline: user.isOnline ?? false,
                      ),
                      const SizedBox(width: 12),
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          user.name!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: FontFamily.caros,
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.only(left: 74),
              child: Container(
                decoration: BoxDecoration(
                  color:
                      isMe ? const Color(0xFF20A090) : const Color(0xFF212727),
                  borderRadius: BorderRadius.only(
                    // If it's the FIRST message in the sequence, the bottom corner is flat
                    bottomRight: isMe
                        ? (isNextFromSameSender
                            ? Radius.zero
                            : Radius.circular(50))
                        : Radius.circular(50),
                    bottomLeft: isMe
                        ? Radius.circular(50)
                        : (isNextFromSameSender
                            ? Radius.zero
                            : Radius.circular(50)),

                    // If it's the LAST message in the sequence, the top corner is flat
                    topRight: isMe
                        ? (isPreviousFromSameSender
                            ? Radius.zero
                            : Radius.circular(50))
                        : Radius.circular(50),
                    topLeft: isMe
                        ? Radius.circular(50)
                        : (isPreviousFromSameSender
                            ? Radius.zero
                            : Radius.circular(50)),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  message.text ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: FontFamily.circular,
                  ),
                ),
              ),
            ),
            if (!isNextFromSameSender) // Display the time only on the last message of the group
              Padding(
                padding: const EdgeInsets.only(left: 74, top: 5),
                child: Text(
                  DateFormat.jm()
                      .format(DateTime.parse(message.timestamp ?? '')),
                  style: const TextStyle(
                    color: Color(0xFF797C7B),
                    fontSize: 10,
                    fontFamily: FontFamily.circular,
                  ),
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

  String messageDate(String timestamp) {
    final messageDate = DateTime.parse(timestamp);

    if (messageDate.day == DateTime.now().day) {
      return 'Today';
    } else if (messageDate.day ==
        DateTime.now().subtract(const Duration(days: 1)).day) {
      return 'Yesterday';
    } else {
      return DateFormat('dd/MM/yyyy').format(
        DateTime.parse(timestamp),
      );
    }
  }
}
