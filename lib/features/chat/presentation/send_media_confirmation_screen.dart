import 'dart:io';

import 'package:chatapp/core/providers/firebase_auth_providers.dart';
import 'package:chatapp/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:chatapp/features/chat/data/repositories/chat_repository.dart';
import 'package:chatapp/features/chat/presentation/providers/video_to_send_progress_provider.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_icon_button.dart';
import 'package:chatapp/features/media/data/repositories/media_repository.dart';
import 'package:chatapp/features/users/data/repositories/user_repository.dart';
import 'package:chatapp/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

class SendMediaConfirmationScreen extends ConsumerStatefulWidget {
  final String chatId;
  final String mediaFilePath;
  const SendMediaConfirmationScreen(
      {required this.chatId, required this.mediaFilePath, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SendMediaConfirmationScreenState();
}

class _SendMediaConfirmationScreenState
    extends ConsumerState<SendMediaConfirmationScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.file(File(widget.mediaFilePath))
      ..initialize().then(
        (value) => setState(() {}),
      )
      ..play();

    _controller.addListener(() {
      ref.read(videoToSendProgressProvider.notifier).state =
          _controller.value.position.inMilliseconds.toDouble();
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
    final chatRepo = ref.watch(chatRepositoryProvider);
    final userRepo = ref.watch(userRepositoryProvider);
    final currentUser = ref.watch(currentUserProvider).asData?.value;
    final videoProgress = ref.watch(videoToSendProgressProvider);

    final media = File(widget.mediaFilePath);
    final mediaFormat = media.path.split(".").last;
    final isVideo = mediaFormat == 'mp4';

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: AuthBackButton(),
          title: Text(
            "Send ${isVideo ? "Video" : "Image"}",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 20,
                ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            if (mediaFormat == 'mp4')
              Expanded(
                child: Center(
                  child: _controller.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
              ),
            if (mediaFormat == 'jpg' ||
                mediaFormat == 'png' ||
                mediaFormat == 'jpeg')
              Expanded(
                child: Center(
                  child: Image.file(media, height: 250, fit: BoxFit.cover),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (mediaFormat == 'mp4')
                    Slider(
                      value: videoProgress,
                      min: 0.0,
                      max: _controller.value.duration.inMilliseconds.toDouble(),
                      onChanged: (double value) {
                        _controller
                            .seekTo(Duration(milliseconds: value.toInt()));
                        ref.read(videoToSendProgressProvider.notifier).state =
                            value;
                      },
                    ),
                  if (mediaFormat == 'mp4')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "${_controller.value.position.inMinutes.remainder(60).toString().padLeft(2, '0')}:${_controller.value.position.inSeconds.remainder(60).toString().padLeft(2, '0')}"),
                        Text(
                            "${_controller.value.duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${_controller.value.duration.inSeconds.remainder(60).toString().padLeft(2, '0')}"),
                      ],
                    ),
                  if (mediaFormat == 'mp4')
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StreamBuilder(
                        stream: chatRepo.getChatDetails(widget.chatId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          final chat = snapshot.data!;
                          final friendId = chat.participants!.firstWhere(
                            (id) => id != currentUser!.uid,
                            orElse: () => '',
                          );

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Sending to:"),
                              const SizedBox(width: 10),
                              StreamBuilder(
                                  stream: userRepo.getUserDetails(friendId),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    final user = snapshot.data!;
                                    return Text(
                                      user.name!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            fontSize: 14,
                                          ),
                                    );
                                  }),
                            ],
                          );
                        },
                      ),
                      ChatIconButton(
                        iconPath: Assets.icons.send.path,
                        backgroundColor: Color(0xFF20A090),
                        onPressed: () {
                          _sendMedia(ref, media, isVideo);
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendMedia(WidgetRef ref, File mediaFile, bool isVideo) async {
    final mediaRepo = ref.read(mediaRepositoryProvider);

    Fluttertoast.showToast(msg: "Uploading ${isVideo ? 'video' : 'image'}...");

    final mediaUrl = await mediaRepo.uploadMedia(mediaFile, isVideo: isVideo);

    if (mediaUrl != null) {
      final chatRepo = ref.read(chatRepositoryProvider);
      chatRepo.sendMessage(widget.chatId, mediaUrl, true, isVideo);

      Fluttertoast.showToast(msg: "${isVideo ? 'Video' : 'Image'} sent!");
      context.pop();
    } else {
      Fluttertoast.showToast(
          msg: "Failed to upload ${isVideo ? 'video' : 'image'}");
    }
  }
}
