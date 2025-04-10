import 'package:chatapp/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_profile_pic.dart';
import 'package:chatapp/features/stories/data/repositories/stories_repository.dart';
import 'package:chatapp/features/stories/presentation/providers/selected_story_index_provider.dart';
import 'package:chatapp/features/stories/presentation/utils/calculate_time_since_story_posted.dart';
import 'package:chatapp/features/stories/presentation/widgets/story_progress_bar.dart';
import 'package:chatapp/features/users/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ViewStoryScreen extends ConsumerStatefulWidget {
  final String friendId;
  const ViewStoryScreen({required this.friendId, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ViewStoryScreenState();
}

class _ViewStoryScreenState extends ConsumerState<ViewStoryScreen> {
  @override
  Widget build(BuildContext context) {
    final storiesRepo = ref.watch(storiesRepositoryProvider);
    final userRepo = ref.watch(userRepositoryProvider);
    final selectedStoryIndex = ref.watch(selectedStoryIndexProvider);

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

            return Stack(
              children: [
                Center(
                  child: Image(
                    image: NetworkImage(
                      stories[selectedStoryIndex]!.mediaURL ?? '',
                    ),
                    fit: BoxFit.cover,
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
                          if (selectedStoryIndex == stories.length - 1) return;
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
                                          isOnline: true,
                                          avatarRadius: 26,
                                          chatPhotoURL: friend.photoURL,
                                        ),
                                        const SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              friend.name ?? '',
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
                                                      .createdAt),
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
                    Column(
                      children: [
                        Container(
                          color: Colors.black.withAlpha(100),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 8),
                              child: Text(
                                textAlign: TextAlign.center,
                                stories[selectedStoryIndex]!.caption ?? '',
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.black.withAlpha(100),
                          child: Row(
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
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }

                                  final isLiked = snapshot.data ?? false;
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Theme.of(context).cardColor,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(50),
                                        onTap: () {},
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          width: 48,
                                          height: 48,
                                          child: isLiked
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
                        ),
                      ],
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
}
