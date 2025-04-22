import 'package:chatapp/core/localization/app_localization.dart';
import 'package:chatapp/core/localization/locale_provider.dart';
import 'package:chatapp/core/providers/firebase_auth_providers.dart';
import 'package:chatapp/core/theme/is_dark_mode.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_profile_pic.dart';
import 'package:chatapp/features/stories/data/repositories/stories_repository.dart';
import 'package:chatapp/features/stories/presentation/widgets/segmented_circle.dart';
import 'package:chatapp/features/users/data/repositories/user_repository.dart';
import 'package:chatapp/gen/fonts.gen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ChatStoriesRow extends ConsumerStatefulWidget {
  const ChatStoriesRow({super.key});

  @override
  _ChatStoriesRowState createState() => _ChatStoriesRowState();
}

class _ChatStoriesRowState extends ConsumerState<ChatStoriesRow> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider).asData?.value;
    final storiesRepo = ref.watch(storiesRepositoryProvider);
    final userRepo = ref.watch(userRepositoryProvider);

    final locale = ref.watch(localeProvider);
    final localization = ref.watch(localizationProvider(locale)).value;

    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Column(
              children: [
                Material(
                  color: Colors.transparent,
                  child: StreamBuilder(
                    stream: storiesRepo.getStoriesByUserId(currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final stories = snapshot.data;

                      return InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () => stories!.isEmpty
                            ? _pickMedia(ref)
                            : _showStoryOptionSelectionBottomSheet(currentUser),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            StreamBuilder(
                              stream: userRepo.getUserDetails(currentUser.uid),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }

                                final user = snapshot.data;
                                return SegmentedCircle(
                                  segmentCount: stories!.length,
                                  child: ChatProfilePic(
                                    avatarRadius: 26,
                                    chatPhotoURL: user!.photoURL,
                                    isOnline: false,
                                  ),
                                );
                              },
                            ),
                            Container(
                              height: 16,
                              width: 16,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isDarkMode(ref, context)
                                      ? Color(0xFF4B9289)
                                      : Color(0xFF363F3B),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white,
                              ),
                              child: Icon(Icons.add,
                                  size: 10, color: Color(0xFF24786D)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  localization?.translate("my-stories") ?? "",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: FontFamily.caros,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder(
            stream: storiesRepo.getFriendsWhoHaveStories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text('Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red)));
              }

              final friendsWhoHaveStories = snapshot.data;
              if (friendsWhoHaveStories!.isEmpty) {
                return SizedBox();
              }

              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: friendsWhoHaveStories.length,
                itemBuilder: (context, index) {
                  final friend = friendsWhoHaveStories[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Column(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              context.push('/view-story/${friend.uid}');
                            },
                            child: StreamBuilder(
                              stream:
                                  storiesRepo.getStoriesByUserId(friend!.uid!),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }

                                final stories = snapshot.data;

                                return StreamBuilder(
                                  stream:
                                      userRepo.getUserDetails(friend.uid ?? ''),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }

                                    final user = snapshot.data;
                                    return SegmentedCircle(
                                      segmentCount: stories!.length,
                                      child: ChatProfilePic(
                                        avatarRadius: 26,
                                        chatPhotoURL: user?.photoURL,
                                        isOnline: false,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        StreamBuilder(
                          stream: userRepo.getUserDetails(
                              friendsWhoHaveStories[index]!.uid ?? ''),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            final user = snapshot.data;
                            return Text(
                              user?.name ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: FontFamily.caros,
                                fontSize: 14,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _pickMedia(WidgetRef ref) async {
    // TODO: DOENS'T WORK IN WEB, FIX
    if (kIsWeb) {
      Fluttertoast.showToast(msg: "Not supported in web for now");
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickMedia();
    final pickedFileFormat = pickedFile?.path.split(".").last;

    final local = ref.watch(localeProvider);
    final localization = ref.watch(localizationProvider(local)).value;

    if (pickedFile != null && pickedFileFormat == "mp4" ||
        pickedFileFormat == "jpg" ||
        pickedFileFormat == "png" ||
        pickedFileFormat == "jpeg") {
      context.push('/send-story-confirmation/?mediaPath=${pickedFile!.path}');
    } else if (pickedFileFormat == null) {
    } else {
      Fluttertoast.showToast(
          msg:
              "${localization!.translate("invalid-media-format")}: $pickedFileFormat");
    }
  }

  void _showStoryOptionSelectionBottomSheet(User? currentUser) {
    final locale = ref.watch(localeProvider);
    final localization = ref.watch(localizationProvider(locale)).value;

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              leading: const Icon(
                Icons.photo_library_outlined,
              ),
              title: Text(
                localization?.translate("see-my-stories") ?? "",
              ),
              onTap: () {
                context.pop();
                context.push('/view-story/${currentUser!.uid}');
              },
            ),
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              leading: const Icon(
                Icons.add,
              ),
              title: Text(
                localization?.translate("add-new-story") ?? "",
              ),
              onTap: () {
                context.pop();
                _pickMedia(ref);
              },
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
