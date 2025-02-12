import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthTextField extends ConsumerWidget {
  final TextEditingController controller;
  bool obscureText;
  final String labelText;
  AuthTextField({
    super.key,
    required this.controller,
    this.obscureText = false,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Color(0xFF5EBAAE),
          fontFamily: FontFamily.circular,
          fontSize: 14,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF595E5C)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF5EBAAE)),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF595E5C)),
        ),
      ),
      style: TextStyle(
        color: Colors.white,
        fontFamily: FontFamily.caros,
        fontSize: 16,
      ),
    );
  }
}
