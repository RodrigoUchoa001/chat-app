import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnBoardSignUpButton extends ConsumerWidget {
  const OnBoardSignUpButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: const Text(
        "Sign up with email",
        style: TextStyle(
          color: Colors.black,
          fontFamily: FontFamily.caros,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
