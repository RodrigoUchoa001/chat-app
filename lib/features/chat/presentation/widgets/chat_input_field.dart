import 'package:chatapp/features/chat/presentation/widgets/chat_icon_button.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_text_field.dart';
import 'package:chatapp/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatInputField extends ConsumerWidget {
  const ChatInputField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatTextFieldController = TextEditingController();

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
            ChatIconButton(iconPath: Assets.icons.clip.path),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ChatTextField(controller: chatTextFieldController),
              ),
            ),
            ChatIconButton(iconPath: Assets.icons.camera.path),
            SizedBox(width: 16),
            ChatIconButton(iconPath: Assets.icons.microphone.path),
          ],
        ),
      ),
    );
  }
}
