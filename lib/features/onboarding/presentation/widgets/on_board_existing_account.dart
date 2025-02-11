import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnBoardExistingAccount extends ConsumerWidget {
  const OnBoardExistingAccount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Existing account? ",
          style: TextStyle(
            color: Color(0xFFB9C1BE),
            fontSize: 16,
            fontFamily: FontFamily.circular,
            fontWeight: FontWeight.normal,
          ),
        ),
        GestureDetector(
          onTap: () {
            context.go('/login');
          },
          child: Text(
            "Log in",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: FontFamily.circular,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
