import 'package:chatapp/core/localization/app_localization.dart';
import 'package:chatapp/core/localization/locale_provider.dart';
import 'package:chatapp/core/theme/theme_provider.dart';
import 'package:chatapp/features/chat/data/repositories/chat_repository.dart';
import 'package:chatapp/features/chat/presentation/providers/show_send_message_icon_provider.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_icon_button.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_text_field.dart';
import 'package:chatapp/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
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

  void _sendMessage(WidgetRef ref, BuildContext context) {
    final chatRepo = ref.watch(chatRepositoryProvider);
    final message = _chatTextFieldController.text.trim();
    if (message.isNotEmpty) {
      chatRepo.sendMessage(widget.chatId, message, false, false);
      _chatTextFieldController.clear();

      _focusNode.requestFocus();
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
              onPressed: () => _pickMedia(ref),
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

  Future<void> _pickMedia(WidgetRef ref) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickMedia();
    final pickedFileFormat = pickedFile?.path.split(".").last;

    final local = ref.watch(localeProvider);
    final localization = ref.watch(localizationProvider(local)).value;

    if (pickedFile != null && pickedFileFormat == "mp4" ||
        pickedFileFormat == "jpg" ||
        pickedFileFormat == "png" ||
        pickedFileFormat == "jpeg") {
      context.push(
          '/send-media-confirmation/?chatId=${widget.chatId}&mediaPath=${pickedFile!.path}');
    } else {
      Fluttertoast.showToast(
          msg: localization!.translate("invalid-media-format"));
    }
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
}
