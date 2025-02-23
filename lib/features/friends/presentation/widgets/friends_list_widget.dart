import 'package:chatapp/features/chat/data/repositories/chat_repository.dart';
import 'package:chatapp/features/friends/presentation/providers/friends_providers.dart';
import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FriendsListWidget extends ConsumerWidget {
  const FriendsListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsList = ref.watch(friendsListProvider);
    final chatRepository = ref.watch(chatRepositoryProvider);

    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 26),
      child: friendsList.when(
        data: (friends) {
          if (friends.isEmpty) {
            return Center(
              child: const Text(
                'You have no friends, pathetic!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: FontFamily.circular,
                ),
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My friends',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: FontFamily.caros,
                ),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                itemCount: friends.length,
                itemBuilder: (context, index) => TextButton(
                  onPressed: () async {
                    final chatId = await chatRepository
                        .getPrivateChatIdByFriendId(friends[index]!.uid!);

                    if (chatId != null) {
                      context.push('/chat/$chatId');
                    } else {
                      await chatRepository
                          .createPrivateChat(friends[index]!.uid!);
                      context.push('/chat/${friends[index]!.uid}');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundImage: NetworkImage(
                            friends[index]!.photoURL ?? '',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              friends[index]!.name ?? 'No name',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: FontFamily.caros,
                              ),
                            ),
                            if (friends[index]!.statusMessage != null &&
                                friends[index]!.statusMessage!.isNotEmpty)
                              Text(
                                friends[index]!.statusMessage!,
                                style: TextStyle(
                                  color: Color(0xFF797C7B),
                                  fontSize: 12,
                                  fontFamily: FontFamily.circular,
                                ),
                              )
                            else
                              SizedBox(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        error: (error, stackTrace) => Center(
            child: Text(
          error.toString(),
          style: TextStyle(color: Colors.white),
        )),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
