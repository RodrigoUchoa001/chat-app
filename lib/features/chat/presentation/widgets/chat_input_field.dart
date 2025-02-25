import 'package:chatapp/features/chat/presentation/providers/show_send_message_icon_provider.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_icon_button.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_text_field.dart';
import 'package:chatapp/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatInputField extends ConsumerWidget {
  const ChatInputField({super.key});

  @override
  Widget build(BuildContext context) {
    final showSendMessageIcon = ref.watch(showSendMessageIconProvider);

    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Color(0xFF121414),
        border: Border(
          top: BorderSide(
            color: Color(0xFF192222),
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
              onPressed: () {},
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
                  controller: _chatTextFieldController,
                ),
              ),
            ),
            _buildButtons(showSendMessageIcon),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons(bool showSendMessageIcon) {
    if (showSendMessageIcon) {
      return ChatIconButton(
        iconPath: Assets.icons.send.path,
        backgroundColor: Color(0xFF20A090),
        onPressed: () {},
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
