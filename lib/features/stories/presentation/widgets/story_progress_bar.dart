import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoryProgressBar extends ConsumerWidget {
  final int totalStories;
  final int currentIndex;
  final Duration animationDuration;
  final bool isPaused;

  const StoryProgressBar({
    required this.totalStories,
    required this.currentIndex,
    this.animationDuration = const Duration(seconds: 5),
    this.isPaused = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: List.generate(totalStories, (index) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Stack(
                children: [
                  Container(
                    height: 3,
                    color: Colors.grey.shade400,
                  ),
                  if (index < currentIndex)
                    Container(
                      height: 3,
                      color: Colors.white,
                    )
                  else if (index == currentIndex)
                    AnimatedContainer(
                      duration: isPaused ? Duration.zero : animationDuration,
                      height: 3,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
