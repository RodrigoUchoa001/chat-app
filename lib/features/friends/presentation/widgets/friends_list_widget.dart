import 'package:chatapp/features/auth/data/dto/user_dto.dart';
import 'package:chatapp/features/chat/data/repositories/chat_repository.dart';
import 'package:chatapp/features/chat/domain/repositories/chat_repository_interface.dart';
import 'package:chatapp/features/friends/data/repositories/friends_repository.dart';
import 'package:chatapp/features/friends/presentation/providers/friends_providers.dart';
import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class FriendsListWidget extends ConsumerWidget {
  const FriendsListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsList = ref.watch(friendsListProvider);
    final friendRequests = ref.watch(friendRequestsProvider);
    final friendRequestCount = ref.watch(friendsRequestCountProvider);
    final chatRepository = ref.watch(chatRepositoryProvider);
    final friendsRepository = ref.watch(friendsRepositoryProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 26),
      child: Column(
        children: [
          friendRequests.when(
            data: (friendRequests) {
              if (friendRequests.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'You have ${friendRequests.length} friend request${friendRequests.length > 1 ? 's' : ''}:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: FontFamily.caros,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: friendRequests.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: const Color(0xFF242E2E),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 51 / 2,
                                        backgroundImage: NetworkImage(
                                          friendRequests[index]!.photoURL ?? '',
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            friendRequests[index]!.name ??
                                                'No name',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontFamily: FontFamily.caros,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 40,
                                        child: FilledButton(
                                          style: FilledButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF3E9D9D),
                                          ),
                                          onPressed: () {
                                            friendsRepository
                                                .acceptFriendRequest(
                                                    friendRequests[index]!
                                                        .uid!);

                                            Fluttertoast.showToast(
                                              msg: 'Friend request accepted',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                                  const Color(0xFF3E9D9D),
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                          },
                                          child: const Text(
                                            'Accept',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: FontFamily.circular,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        height: 40,
                                        child: TextButton(
                                          onPressed: () {
                                            friendsRepository
                                                .rejectFriendRequest(
                                                    friendRequests[index]!
                                                        .uid!);

                                            Fluttertoast.showToast(
                                              msg: 'Friend request declined',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                                  const Color(0xFF3E9D9D),
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            );
                                          },
                                          child: const Text(
                                            'Decline',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: FontFamily.circular,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              }
              return Container();
            },
            error: (error, stackTrace) => Center(
                child: Text(
              error.toString(),
              style: TextStyle(color: Colors.white),
            )),
            loading: () => Center(child: CircularProgressIndicator()),
          ),
          if (friendRequestCount.value! > 0)
            Column(children: [
              const SizedBox(height: 10),
              const Divider(color: Colors.white),
              const SizedBox(height: 10),
            ]),
          friendsList.when(
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: const Text(
                      'My friends',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: FontFamily.caros,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: friends.length,
                    itemBuilder: (context, index) {
                      bool isTheFirstFriendWithThisLetter = index == 0 ||
                          friends[index - 1]!.name![0] !=
                              friends[index]!.name![0];

                      return Column(
                        children: [
                          if (isTheFirstFriendWithThisLetter)
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 24,
                                  right: 24,
                                  top: index == 0 ? 0 : 30,
                                  bottom: 20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  friends[index]!.name![0],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: FontFamily.caros,
                                  ),
                                ),
                              ),
                            ),
                          friendButton(chatRepository, friends, index, context),
                        ],
                      );
                    },
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
        ],
      ),
    );
  }

  Widget friendButton(ChatRepositoryInterface chatRepository,
      List<UserDTO?> friends, int index, BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          final chatId = await chatRepository
              .getPrivateChatIdByFriendId(friends[index]!.uid!);

          if (chatId != null) {
            context.push('/chat/$chatId');
          } else {
            await chatRepository.createPrivateChat(friends[index]!.uid!);
            context.push('/chat/${friends[index]!.uid}');
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 51 / 2,
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
    );
  }
}
