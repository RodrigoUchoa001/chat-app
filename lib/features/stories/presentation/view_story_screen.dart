import 'package:chatapp/features/chat/presentation/widgets/chat_profile_pic.dart';
import 'package:chatapp/features/stories/presentation/widgets/story_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewStoryScreen extends ConsumerStatefulWidget {
  final String storyId;
  const ViewStoryScreen({required this.storyId, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ViewStoryScreenState();
}

class _ViewStoryScreenState extends ConsumerState<ViewStoryScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: Image(
                image: NetworkImage(
                  'https://picsum.photos/200/300',
                ),
                fit: BoxFit.cover,
                height: double.infinity,
              ),
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
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: StoryProgressBar(
                              totalStories: 5,
                              currentIndex: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                ChatProfilePic(
                                  isOnline: true,
                                  avatarRadius: 45,
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Username',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                    ),
                                    Text(
                                      '40min ago',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            fontSize: 12,
                                            color: Colors.white.withAlpha(200),
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.black.withAlpha(100),
                  child: const Center(
                    child: Text('Story Caption'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
