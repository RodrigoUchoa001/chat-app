import 'package:chatapp/core/localization/app_localization.dart';
import 'package:chatapp/core/localization/locale_provider.dart';
import 'package:chatapp/core/providers/firebase_auth_providers.dart';
import 'package:chatapp/core/theme/theme_provider.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_profile_pic.dart';
import 'package:chatapp/features/stories/data/repositories/stories_repository.dart';
import 'package:chatapp/features/users/data/repositories/user_repository.dart';
import 'package:chatapp/gen/fonts.gen.dart';
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
    final themeMode = ref.watch(themeProvider);

    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // TODO: add the option to add a new story
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Column(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () => _pickMedia(ref),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          height: 58,
                          width: 58,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: themeMode == ThemeMode.dark ||
                                      (themeMode == ThemeMode.system &&
                                          MediaQuery.of(context)
                                                  .platformBrightness ==
                                              Brightness.dark)
                                  ? Color(0xFF4B9289)
                                  : Color(0xFF363F3B),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: ChatProfilePic(
                              avatarRadius: 26,
                              chatPhotoURL: currentUser?.photoURL,
                              isOnline: false,
                            ),
                          ),
                        ),
                        Container(
                          height: 16,
                          width: 16,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: themeMode == ThemeMode.dark ||
                                      (themeMode == ThemeMode.system &&
                                          MediaQuery.of(context)
                                                  .platformBrightness ==
                                              Brightness.dark)
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
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'My Status',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: FontFamily.caros,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // TODO: add the option see friends stories
          StreamBuilder(
            stream: storiesRepo.getFriendsWhoHaveStories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                print(snapshot.error);
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Column(
                      children: [
                        Container(
                          height: 58,
                          width: 58,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: themeMode == ThemeMode.dark ||
                                      (themeMode == ThemeMode.system &&
                                          MediaQuery.of(context)
                                                  .platformBrightness ==
                                              Brightness.dark)
                                  ? Color(0xFF4B9289)
                                  : Color(0xFF363F3B),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: StreamBuilder(
                              stream: userRepo.getUserDetails(
                                  friendsWhoHaveStories[index]!.uid ?? ''),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }

                                final user = snapshot.data;
                                return ChatProfilePic(
                                  avatarRadius: 26,
                                  chatPhotoURL: user?.photoURL,
                                  isOnline: false,
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
}
