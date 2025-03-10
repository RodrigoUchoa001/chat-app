import 'package:chatapp/core/providers/firebase_auth_providers.dart';
import 'package:chatapp/core/widgets/chat_text_button.dart';
import 'package:chatapp/features/chat/data/repositories/chat_repository.dart';
import 'package:chatapp/features/chat/presentation/providers/friends_list_to_create_group_provider.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_profile_pic.dart';
import 'package:chatapp/features/users/data/repositories/user_repository.dart';
import 'package:chatapp/gen/assets.gen.dart';
import 'package:chatapp/gen/fonts.gen.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final groupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider).asData?.value;
    final userRepo = ref.watch(userRepositoryProvider);
    final chatRepo = ref.watch(chatRepositoryProvider);

    final friendsListToCreateGroup =
        ref.watch(friendsListToCreateGroupProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF121414),
        appBar: AppBar(
          toolbarHeight: 124,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: SvgPicture.asset(
              Assets.icons.backButton.path,
              fit: BoxFit.scaleDown,
              width: 18,
              height: 18,
            ),
            onPressed: () {
              context.pop();
              friendsListToCreateGroup.clear();
            },
          ),
          centerTitle: true,
          title: const Text(
            'Create Group',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: FontFamily.caros,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Group Name',
                      style: TextStyle(
                        color: Color(0xFF797C7B),
                        fontSize: 16,
                        fontFamily: FontFamily.caros,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: groupNameController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontFamily: FontFamily.caros,
                      ),
                      maxLines: 1,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type the Group Name',
                        hintStyle: const TextStyle(
                          color: Color(0xFF797C7B),
                          fontSize: 40,
                          fontFamily: FontFamily.caros,
                        ),
                      ),
                      autofocus: true,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Group Admin',
                      style: TextStyle(
                        color: Color(0xFF797C7B),
                        fontSize: 16,
                        fontFamily: FontFamily.caros,
                      ),
                    ),
                    const SizedBox(height: 20),
                    StreamBuilder(
                      stream: userRepo.getUserDetails(currentUser!.uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        final user = snapshot.data!;
                        final isPhotoValid = user.photoURL != null &&
                            user.photoURL!.isNotEmpty &&
                            user.photoURL != 'null';

                        return Row(
                          children: [
                            isPhotoValid
                                ? ChatProfilePic(
                                    chatPhotoURL: user.photoURL,
                                    isOnline: false,
                                  )
                                : ChatProfilePic(
                                    isOnline: false,
                                  ),
                            const SizedBox(width: 12),
                            Text(
                              user.name != null ? '${user.name} (You)' : '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: FontFamily.caros,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Invited Members',
                      style: TextStyle(
                        color: Color(0xFF797C7B),
                        fontSize: 16,
                        fontFamily: FontFamily.caros,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 16,
                      runSpacing: 20,
                      children: [
                        for (final friend in friendsListToCreateGroup)
                          GestureDetector(
                            onTap: () => _removeUserFromGroup(ref, friend.uid!),
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                ChatProfilePic(
                                  chatPhotoURL: friend.photoURL,
                                  isOnline: false,
                                  avatarRadius:
                                      36, // half the size of the material widget above (70/2), plus 1 pixel for the border
                                ),
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(0xFF121414),
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(50),
                                    color: Color(0xFFEA3736),
                                  ),
                                  child: Icon(Icons.close,
                                      color: Colors.white, size: 16),
                                ),
                              ],
                            ),
                          ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              context.push('/select-friends-to-create-group');
                            },
                            child: DottedBorder(
                              dashPattern: [8, 4],
                              borderType: BorderType.Circle,
                              color: Color(0xFF323C37),
                              child: SizedBox(
                                height: 70,
                                width: 70,
                                child: Icon(
                                  Icons.add,
                                  size: 24,
                                  color: Color(0xFF323C37),
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
              ChatTextButton(
                onTap: friendsListToCreateGroup.isEmpty
                    ? null
                    : () async {
                        final chatId = await chatRepo.createGroupChat(
                          groupName: groupNameController.text,
                          groupPhotoURL:
                              'https://wallpapers.com/images/high/placeholder-profile-icon-1eyvi6hml9stfg4c-1eyvi6hml9stfg4c.png',
                          participants: [
                            currentUser.uid,
                            ...friendsListToCreateGroup
                                .map((user) => user.uid!),
                          ],
                        );
                        context.pushReplacement('/chat/$chatId');
                        friendsListToCreateGroup.clear();
                      },
                text: "Create",
                buttonColor: Color(0xFF24786D),
                textColor: Colors.white,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _removeUserFromGroup(WidgetRef ref, String uid) {
    ref.read(friendsListToCreateGroupProvider.notifier).update((state) {
      return state.where((user) => user.uid != uid).toList();
    });
  }
}
