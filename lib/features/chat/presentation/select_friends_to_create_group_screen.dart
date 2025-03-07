import 'package:chatapp/features/auth/data/dto/user_dto.dart';
import 'package:chatapp/features/chat/presentation/providers/friends_list_to_create_group_provider.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_profile_pic.dart';
import 'package:chatapp/features/friends/data/repositories/friends_repository.dart';
import 'package:chatapp/gen/assets.gen.dart';
import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SelectFriendsToCreateGroupScreen extends ConsumerStatefulWidget {
  const SelectFriendsToCreateGroupScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectFriendsToCreateGroupScreenState();
}

class _SelectFriendsToCreateGroupScreenState
    extends ConsumerState<SelectFriendsToCreateGroupScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final friendsRepo = ref.watch(friendsRepositoryProvider);
    final friendsListToCreateGroup =
        ref.watch(friendsListToCreateGroupProvider);
    final query = _searchController.text.toLowerCase();

    final friendsStream = friendsRepo.searchFriends(query);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF121414),
        appBar: AppBar(
          backgroundColor: Color(0xFF121414),
          leadingWidth: 44,
          leading: IconButton(
            icon: SvgPicture.asset(
              Assets.icons.backButton.path,
              fit: BoxFit.scaleDown,
              width: 18,
              height: 18,
            ),
            onPressed: () {
              context.pop();
            },
          ),
          title: Container(
            height: 44,
            decoration: BoxDecoration(
              color: Color(0xFF192222),
              border: Border(
                top: BorderSide(
                  color: Color(0xFF192222),
                  width: 1,
                ),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {});
              },
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: FontFamily.circular,
              ),
              cursorColor: Colors.white,
              autofocus: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: SvgPicture.asset(
                    Assets.icons.search.path,
                    fit: BoxFit.scaleDown,
                    width: 20,
                    height: 20,
                  ),
                ),
                filled: true,
                fillColor: Color(0xFF192222),
                hintText: 'Type to search',
                hintStyle: TextStyle(
                  color: Color(0xFF797C7B),
                  fontSize: 12,
                  fontFamily: FontFamily.circular,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            if (friendsListToCreateGroup.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '${friendsListToCreateGroup.length} friend${friendsListToCreateGroup.length > 1 ? 's' : ''} selected:',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: FontFamily.caros,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: friendsListToCreateGroup.map(
                      (friend) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: GestureDetector(
                            onTap: () => _removeUserFromGroup(ref, friend.uid!),
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                ChatProfilePic(
                                  chatPhotoURL: friend.photoURL,
                                  isOnline: false,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(0xFF121414),
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(50),
                                    color: Color(0xFFEA3736),
                                  ),
                                  child: Icon(Icons.close,
                                      color: Colors.white, size: 12),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
            // const SizedBox(height: 10),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  StreamBuilder(
                    stream: friendsStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (!snapshot.hasData) return const SizedBox();
                      final friends = snapshot.data!;
                      if (friends.isEmpty) return const SizedBox();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 20),
                            child: Text(
                              'Select friends to create group:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: FontFamily.caros,
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: friends.length,
                            itemBuilder: (context, index) {
                              final friend = friends[index];
                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () async {},
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ChatProfilePic(
                                          chatPhotoURL: friend.photoURL,
                                          isOnline: friend.isOnline ?? false,
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              friend.name ?? '',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: FontFamily.caros,
                                              ),
                                            ),
                                            if (friend.statusMessage != null &&
                                                friend
                                                    .statusMessage!.isNotEmpty)
                                              Text(
                                                friends[index]!.statusMessage!,
                                                style: TextStyle(
                                                  color: Color(0xFF797C7B),
                                                  fontSize: 12,
                                                  fontFamily:
                                                      FontFamily.circular,
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
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addUserToGroup(WidgetRef ref, UserDTO user) {
    ref.read(friendsListToCreateGroupProvider.notifier).update((state) {
      if (state.any((u) => u.uid == user.uid)) {
        return state; // 🔥 Evita duplicatas
      }
      return [...state, user];
    });
  }

  void _removeUserFromGroup(WidgetRef ref, String uid) {
    ref.read(friendsListToCreateGroupProvider.notifier).update((state) {
      return state.where((user) => user.uid != uid).toList();
    });
  }

  bool _isFriendSelected(WidgetRef ref, String uid) {
    return ref
        .read(friendsListToCreateGroupProvider.notifier)
        .state
        .any((user) => user.uid == uid);
  }
}
