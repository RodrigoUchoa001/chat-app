import 'package:chatapp/core/localization/app_localization.dart';
import 'package:chatapp/core/localization/locale_provider.dart';
import 'package:chatapp/core/providers/firebase_auth_providers.dart';
import 'package:chatapp/core/widgets/media_player_widget.dart';
import 'package:chatapp/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_profile_pic.dart';
import 'package:chatapp/features/stories/data/dto/story_dto.dart';
import 'package:chatapp/features/stories/data/repositories/stories_repository.dart';
import 'package:chatapp/features/stories/presentation/providers/is_story_liked_by_me_provider.dart';
import 'package:chatapp/features/stories/presentation/providers/selected_story_index_provider.dart';
import 'package:chatapp/features/stories/presentation/utils/calculate_time_since_story_posted.dart';
import 'package:chatapp/features/stories/presentation/widgets/story_progress_bar.dart';
import 'package:chatapp/features/users/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class ViewStoryScreen extends ConsumerStatefulWidget {
  final String friendId;
  const ViewStoryScreen({required this.friendId, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ViewStoryScreenState();
}

class _ViewStoryScreenState extends ConsumerState<ViewStoryScreen> {
  @override
  void initState() {
    resetStoryIndex();
    super.initState();
  }

  // reset the story index, so, when, for example, if the user views two stories,
  // left the view story screen and goes to the view story screen again, it will
  // start from the first story
  Future<void> resetStoryIndex() async {
    await Future.delayed(const Duration(milliseconds: 1), () {
      ref.read(selectedStoryIndexProvider.notifier).state = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final storiesRepo = ref.watch(storiesRepositoryProvider);
    final userRepo = ref.watch(userRepositoryProvider);
    final selectedStoryIndex = ref.watch(selectedStoryIndexProvider);
    final isStoryLikedByMe = ref.watch(isStoryLikedByMeProvider);
    final currentUser = ref.watch(currentUserProvider).asData?.value;

    final locale = ref.watch(localeProvider);
    final localization = ref.watch(localizationProvider(locale)).value;

    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: storiesRepo.getStoriesByUserId(widget.friendId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final stories = snapshot.data;
            if (stories!.isEmpty) {
              return Center(
                child: Text(
                  'No stories',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 24,
                      ),
                ),
              );
            }

            // marking story as seen
            storiesRepo.markStoryAsSeen(stories[selectedStoryIndex]!.id!);

            return Stack(
              children: [
                Center(
                  child: MediaPlayerWidget(
                    mediaUrl: stories[selectedStoryIndex]!.mediaURL!,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (selectedStoryIndex == 0) return;
                          ref.read(selectedStoryIndexProvider.notifier).state--;
                        },
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (selectedStoryIndex == stories.length - 1) {
                            return context.pop();
                          }
                          ref.read(selectedStoryIndexProvider.notifier).state++;
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withAlpha(200),
                                  Colors.transparent
                                ],
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              const SizedBox(height: 4),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: StoryProgressBar(
                                  totalStories: stories.length,
                                  currentIndex: selectedStoryIndex,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: StreamBuilder(
                                  stream:
                                      userRepo.getUserDetails(widget.friendId),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }

                                    final friend = snapshot.data;
                                    if (friend == null) {
                                      Fluttertoast.showToast(
                                        msg: 'User not found',
                                      );
                                      return const Text('User not found');
                                    }

                                    return Row(
                                      children: [
                                        AuthBackButton(),
                                        const SizedBox(width: 12),
                                        ChatProfilePic(
                                          isOnline: false,
                                          avatarRadius: 26,
                                          chatPhotoURL: friend.photoURL,
                                        ),
                                        const SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              currentUser!.uid ==
                                                      widget.friendId
                                                  ? localization
                                                          ?.translate("you") ??
                                                      ""
                                                  : friend.name ?? '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                  ),
                                            ),
                                            Text(
                                              calculateTimeSinceStoryPosted(
                                                  stories[selectedStoryIndex]!
                                                      .createdAt,
                                                  ref),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    fontSize: 12,
                                                    color: Colors.white
                                                        .withAlpha(200),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: stories[selectedStoryIndex]!.caption!.isNotEmpty
                          ? Colors.black.withAlpha(100)
                          : Colors.transparent,
                      child: Column(
                        children: [
                          if (stories[selectedStoryIndex]!.caption!.isNotEmpty)
                            Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 8),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  stories[selectedStoryIndex]!.caption ?? '',
                                ),
                              ),
                            ),
                          stories[selectedStoryIndex]!.userId ==
                                  currentUser?.uid
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _storyButton(
                                      context,
                                      stories,
                                      selectedStoryIndex,
                                      Icon(Icons.favorite),
                                      '${stories[selectedStoryIndex]!.likes?.length ?? 0}',
                                      () {
                                        _showStoryListBottomSheet(
                                          localization?.translate("likes") ??
                                              "",
                                          stories[selectedStoryIndex]!.likes!,
                                          true,
                                        );
                                      },
                                    ),
                                    SizedBox(width: 8),
                                    _storyButton(
                                      context,
                                      stories,
                                      selectedStoryIndex,
                                      Icon(Icons.remove_red_eye),
                                      '${stories[selectedStoryIndex]!.views?.length ?? 0}',
                                      () {
                                        _showStoryListBottomSheet(
                                          localization?.translate("views") ??
                                              "",
                                          stories[selectedStoryIndex]!.views!,
                                          false,
                                        );
                                      },
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    const Spacer(),
                                    StreamBuilder(
                                      stream: storiesRepo.isStoryLikedByMe(
                                        stories[selectedStoryIndex]!.id ?? '',
                                      ),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        }

                                        final isLiked = snapshot.data ?? false;
                                        // this fix the error of setState() called during build
                                        Future.delayed(
                                            Duration(milliseconds: 1), () {
                                          ref
                                              .read(
                                                isStoryLikedByMeProvider
                                                    .notifier,
                                              )
                                              .state = isLiked;
                                        });

                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Theme.of(context).cardColor,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              onTap: () {
                                                if (isLiked) {
                                                  storiesRepo.unlikeStory(
                                                    stories[selectedStoryIndex]!
                                                            .id ??
                                                        '',
                                                  );
                                                  ref
                                                      .read(
                                                        isStoryLikedByMeProvider
                                                            .notifier,
                                                      )
                                                      .state = false;
                                                } else {
                                                  storiesRepo.likeStory(
                                                    stories[selectedStoryIndex]!
                                                            .id ??
                                                        '',
                                                  );
                                                  ref
                                                      .read(
                                                        isStoryLikedByMeProvider
                                                            .notifier,
                                                      )
                                                      .state = true;
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                width: 48,
                                                height: 48,
                                                child: isStoryLikedByMe
                                                    ? Icon(Icons.favorite)
                                                    : Icon(Icons
                                                        .favorite_border_outlined),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Padding _storyButton(BuildContext context, List<StoryDTO?> stories,
      int selectedStoryIndex, Icon icon, String text, Function() onTap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(50),
        color: Theme.of(context).cardColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
            ),
            width: 64,
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 4),
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showStoryListBottomSheet(String title, List<String> userIds, bool isLikes) {
    final userRepo = ref.read(userRepositoryProvider);

    final locale = ref.watch(localeProvider);
    final localization = ref.watch(localizationProvider(locale)).value;

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            if (userIds.isEmpty)
              Center(
                child: Text(
                  isLikes
                      ? localization?.translate("no-likes-yet") ?? ""
                      : localization?.translate("no-views-yet") ?? "",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 16,
                      ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                itemCount: userIds.length,
                itemBuilder: (context, index) {
                  final userId = userIds[index];
                  return StreamBuilder(
                    stream: userRepo.getUserDetails(userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      final user = snapshot.data!;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.photoURL ?? ''),
                        ),
                        title: Text(user.name ?? ''),
                      );
                    },
                  );
                },
              ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
