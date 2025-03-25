import 'dart:io';

import 'package:chatapp/core/theme/theme_provider.dart';
import 'package:chatapp/features/chat/data/repositories/chat_repository.dart';
import 'package:chatapp/features/chat/presentation/providers/show_send_message_icon_provider.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_icon_button.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_text_field.dart';
import 'package:chatapp/features/media/data/repositories/media_repository.dart';
import 'package:chatapp/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class ChatInputField extends ConsumerStatefulWidget {
  final String chatId;
  const ChatInputField({required this.chatId, super.key});

  @override
  ConsumerState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends ConsumerState<ChatInputField> {
  late final TextEditingController _chatTextFieldController;
  final FocusNode _focusNode = FocusNode();

  File? _mediaFile;
  String? _uploadedMediaURL;
  bool _isVideo = false;

  void _sendMessage(WidgetRef ref, BuildContext context) {
    final chatRepo = ref.watch(chatRepositoryProvider);
    final message = _chatTextFieldController.text.trim();
    if (message.isNotEmpty) {
      chatRepo.sendMessage(widget.chatId, message, false, false);
      _chatTextFieldController.clear();

      _focusNode.requestFocus();
    }
  }

  Future<void> _pickAndUploadMedia(WidgetRef ref, bool isVideo) async {
    final chatRepo = ref.watch(chatRepositoryProvider);

    final picker = ImagePicker();
    final pickedFile = await picker.pickMedia();

    if (pickedFile != null) {
      setState(() {
        _mediaFile = File(pickedFile.path);
        _isVideo = isVideo;
      });
    }

    final mediaRepo = ref.watch(mediaRepositoryProvider);
    final mediaUrl =
        await mediaRepo.uploadMedia(_mediaFile!, isVideo: _isVideo);

    setState(() {
      _uploadedMediaURL = mediaUrl;
    });

    if (_uploadedMediaURL != null) {
      chatRepo.sendMessage(widget.chatId, _uploadedMediaURL!, true, isVideo);
    }
  }

  @override
  void initState() {
    super.initState();
    _chatTextFieldController = TextEditingController();
  }

  @override
  void dispose() {
    _chatTextFieldController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showSendMessageIcon = ref.watch(showSendMessageIconProvider);

    final themeMode = ref.watch(themeProvider);

    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: themeMode == ThemeMode.dark ||
                (themeMode == ThemeMode.system &&
                    MediaQuery.of(context).platformBrightness ==
                        Brightness.dark)
            ? Border(
                top: BorderSide(
                  color: Color(0xFF192222),
                  width: 1,
                ),
              )
            : Border(
                top: BorderSide(
                  color: Color(0xFFEEFAF8),
                  width: 1,
                ),
              ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            ChatIconButton(
              iconPath: Assets.icons.clip.path,
              onPressed: () => _showMediaOptions(context),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ChatTextField(
                  onChanged: (text) {
                    if (text.isNotEmpty) {
                      ref
                          .read(showSendMessageIconProvider.notifier)
                          .update((state) => true);
                    } else {
                      ref
                          .read(showSendMessageIconProvider.notifier)
                          .update((state) => false);
                    }
                  },
                  onSubmitted: (text) {
                    _sendMessage(ref, context);
                    ref
                        .read(showSendMessageIconProvider.notifier)
                        .update((state) => false);
                  },
                  focusNode: _focusNode,
                  controller: _chatTextFieldController,
                ),
              ),
            ),
            _buildButtons(showSendMessageIcon, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons(bool showSendMessageIcon, WidgetRef ref) {
    if (showSendMessageIcon) {
      return ChatIconButton(
        iconPath: Assets.icons.send.path,
        backgroundColor: Color(0xFF20A090),
        onPressed: () {
          if (_chatTextFieldController.text.isNotEmpty) {
            final chatProvider = ref.watch(chatRepositoryProvider);
            try {
              chatProvider.sendMessage(
                widget.chatId,
                _chatTextFieldController.text,
                false,
                false,
              );
              _chatTextFieldController.clear();
              ref
                  .read(showSendMessageIconProvider.notifier)
                  .update((state) => false);
            } on Exception catch (e) {
              Fluttertoast.showToast(msg: "Error sending message: $e");
            }
          }
        },
      );
    } else {
      return Row(
        children: [
          ChatIconButton(
            iconPath: Assets.icons.camera.path,
            onPressed: () {},
          ),
          SizedBox(width: 16),
          ChatIconButton(
            iconPath: Assets.icons.microphone.path,
            onPressed: () {},
          ),
        ],
      );
    }
  }

  void _showMediaOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Text(
                "Select media format:",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 20,
                    ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _mediaButton(context),
                _mediaButton(context, isVideo: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Padding _mediaButton(BuildContext context, {bool isVideo = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _pickAndUploadMedia(ref, isVideo),
          borderRadius: BorderRadius.circular(50),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Theme.of(context).cardColor,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: null,
                  icon: Icon(
                    isVideo ? Icons.video_call : Icons.image,
                  ),
                ),
                Text(isVideo ? "Video" : "Image",
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
