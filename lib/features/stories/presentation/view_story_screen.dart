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
      child: Scaffold(),
    );
  }
}
