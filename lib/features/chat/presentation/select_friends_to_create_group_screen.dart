import 'package:chatapp/core/providers/firebase_auth_providers.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_profile_pic.dart';
import 'package:chatapp/features/friends/data/repositories/friends_repository.dart';
import 'package:chatapp/features/users/data/repositories/user_repository.dart';
import 'package:chatapp/gen/assets.gen.dart';
import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SelectFriendsToAddCreateScreen extends ConsumerStatefulWidget {
  const SelectFriendsToAddCreateScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectFriendsToAddCreateScreenState();
}

class _SelectFriendsToAddCreateScreenState
    extends ConsumerState<SelectFriendsToAddCreateScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userRepo = ref.watch(userRepositoryProvider);
    final friendRepo = ref.watch(friendsRepositoryProvider);
    final currentUser = ref.watch(currentUserProvider).asData?.value;
    final query = _searchController.text.toLowerCase();

    final searchResults = userRepo.searchUsers(query);

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
                hintText: 'Type to search friends to add',
                hintStyle: TextStyle(
                  color: Color(0xFF797C7B),
                  fontSize: 12,
                  fontFamily: FontFamily.circular,
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              StreamBuilder(
                stream: searchResults,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData) return const SizedBox();
                  final users = snapshot.data!;
                  if (users.isEmpty) return const SizedBox();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        child: Text(
                          'Add Friends',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: FontFamily.caros,
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];

                          // check if the user is the current user itself
                          if (user.uid == currentUser?.uid) {
                            return const SizedBox();
                          }

                          return FutureBuilder(
                              future: friendRepo.isFriend(user.uid!),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox();
                                }

                                // check if the user is already a friend
                                if (snapshot.data == true) {
                                  return const SizedBox();
                                }

                                return Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ChatProfilePic(
                                            chatPhotoURL: user.photoURL,
                                            isOnline: user.isOnline ?? false,
                                          ),
                                          const SizedBox(width: 12),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                user.name ?? '',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: FontFamily.caros,
                                                ),
                                              ),
                                              if (user.statusMessage != null &&
                                                  user.statusMessage!
                                                      .isNotEmpty)
                                                Text(
                                                  users[index].statusMessage!,
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
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24),
                                      child: IconButton(
                                        icon: SvgPicture.asset(
                                            Assets.icons.userAdd.path,
                                            width: 22),
                                        padding: const EdgeInsets.all(7),
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                                  Color(0xFF4B9289)),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              });
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
      ),
    );
  }
}
