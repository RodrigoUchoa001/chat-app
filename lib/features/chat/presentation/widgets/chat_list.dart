import 'package:chatapp/features/chat/data/repositories/fake_chat_repository.dart';
import 'package:chatapp/features/chat/presentation/utils/calculate_time_since_last_message.dart';
import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatList extends ConsumerWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fakeChats = ref.watch(mockUserChatsProvider);

    final unseenMessagesCount = ref.watch(unreadMessagesProvider('user1'));

    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 26),
      child: fakeChats.when(
        data: (chats) => ListView.builder(
          itemCount: chats!.length,
          itemBuilder: (context, index) {
            final chat = chats[index];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundImage: NetworkImage(
                              chat.groupPhotoURL ?? '',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Color(0xFF0FE16D),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chat.groupName ?? 'No name',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: FontFamily.caros,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            chat.lastMessage!.text ?? 'No message',
                            style: TextStyle(
                              color: Color(0xFF797C7B),
                              fontSize: 12,
                              fontFamily: FontFamily.circular,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        calculateTimeSinceLastMessage(
                            chat.lastMessage!.timestamp!),
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
                        error: (error, stackTrace) => Container(),
                        loading: () => Container(),
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
