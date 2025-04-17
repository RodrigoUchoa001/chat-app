import 'dart:io';

import 'package:chatapp/core/providers/firebase_auth_providers.dart';
import 'package:chatapp/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:chatapp/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_icon_button.dart';
import 'package:chatapp/features/media/data/repositories/media_repository.dart';
import 'package:chatapp/features/stories/data/dto/story_dto.dart';
import 'package:chatapp/features/stories/data/repositories/stories_repository.dart';
import 'package:chatapp/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

class SendStoryConfirmationScreen extends ConsumerStatefulWidget {
  final String mediaFilePath;

  const SendStoryConfirmationScreen({
    required this.mediaFilePath,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SendStoryConfirmationScreenState();
}

class _SendStoryConfirmationScreenState
    extends ConsumerState<SendStoryConfirmationScreen> {
  late VideoPlayerController _controller;
  late double videoProgress;

  final _captionController = TextEditingController();

  @override
  void initState() {
    videoProgress = 0.0;
    _controller = VideoPlayerController.file(File(widget.mediaFilePath))
      ..initialize().then(
        (value) => setState(() {}),
      )
      ..play();

    _controller.addListener(() {
      setState(() {
        videoProgress = _controller.value.position.inMilliseconds.toDouble();
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = File(widget.mediaFilePath);
    final mediaFormat = media.path.split(".").last;
    final isVideo = mediaFormat == 'mp4';

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: const AuthBackButton(),
          title: Text(
            "Send ${isVideo ? "Video" : "Image"} Story",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 20,
                ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            if (isVideo)
              Expanded(
                child: Center(
                  child: Center(
                    child: _controller.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          )
                        : const Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
            if (!isVideo)
              Expanded(
                child: Center(
                  child: Image.file(
                    media,
                    width: double.maxFinite,
                    height: double.maxFinite,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            Column(
              children: [
                if (isVideo)
                  Slider(
                    value: videoProgress,
                    min: 0.0,
                    max: _controller.value.duration.inMilliseconds.toDouble(),
                    onChanged: (double value) {
                      _controller.seekTo(Duration(milliseconds: value.toInt()));
                    },
                  ),
                if (isVideo)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                    icon: Icon(_controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: AuthTextField(
                controller: _captionController,
                labelText: "Insert caption",
                validator: (value) => null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: ChatIconButton(
                  iconPath: Assets.icons.send.path,
                  backgroundColor: const Color(0xFF20A090),
                  onPressed: () {
                    _sendStory(ref, media, isVideo);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendStory(WidgetRef ref, File mediaFile, bool isVideo) async {
    final mediaRepo = ref.read(mediaRepositoryProvider);
    final storyRepo = ref.read(storiesRepositoryProvider);
    final currentUser = ref.read(currentUserProvider).value;

    Fluttertoast.showToast(msg: "Uploading ${isVideo ? 'video' : 'image'}...");

    final mediaUrl = await mediaRepo.uploadMedia(mediaFile, isVideo: isVideo);

    if (mediaUrl != null && currentUser != null) {
      await storyRepo.sendStory(
        StoryDTO(
          createdAt: DateTime.now().toString(),
          userId: currentUser.uid,
          mediaURL: mediaUrl,
          mediaType: isVideo ? "video" : "image",
          expiresAt: DateTime.now().add(const Duration(days: 1)).toString(),
          views: [],
          likes: [],
          caption: _captionController.text,
        ),
      );

      Fluttertoast.showToast(msg: "Story posted!");
      context.go('/home');
    } else {
      Fluttertoast.showToast(msg: "Failed to upload story");
    }
  }
}
