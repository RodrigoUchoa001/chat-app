import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatTextField extends ConsumerWidget {
  final TextEditingController controller;
  const ChatTextField({required this.controller, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      controller: controller,
      style: TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontFamily: FontFamily.circular,
      ),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Color(0xFF192222),
        hintText: 'Write your message',
        hintStyle: TextStyle(
          color: Color(0xFF797C7B),
          fontSize: 12,
          fontFamily: FontFamily.circular,
        ),
      ),
    );
  }
}
