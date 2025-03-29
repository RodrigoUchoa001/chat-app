// dont remove
import 'dart:io';

import 'package:chatapp/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class ViewMediaScreen extends ConsumerStatefulWidget {
  final String mediaUrl;
  const ViewMediaScreen({required this.mediaUrl, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ViewMediaScreenState();
}

class _ViewMediaScreenState extends ConsumerState<ViewMediaScreen> {
  late VideoPlayerController _controller;
  late double videoProgress;

  @override
  void initState() {
    videoProgress = 0.0;
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.mediaUrl))
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
    final mediaFormat = widget.mediaUrl.split(".").last;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: AuthBackButton(),
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
              )
            else if (mediaFormat == 'jpg' ||
                mediaFormat == 'png' ||
                mediaFormat == 'jpeg')
              Expanded(
                child: Center(
                  child: Image.network(
                    widget.mediaUrl,
                    width: double.maxFinite,
                    height: double.maxFinite,
                    fit: BoxFit.contain,
                  ),
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
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (double value) {
                        _controller
                            .seekTo(Duration(milliseconds: value.toInt()));
                        setState(() {
                          videoProgress = value;
                        });
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
