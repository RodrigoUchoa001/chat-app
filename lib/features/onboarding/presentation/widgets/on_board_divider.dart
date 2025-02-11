import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnBoardDivider extends ConsumerWidget {
  const OnBoardDivider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            color: Color(0xFFCDD1D0).withAlpha(51),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: const Text(
            "OR",
            style: TextStyle(
              color: Color(0xFFD6E4E0),
              fontSize: 16,
              fontFamily: FontFamily.circular,
              fontWeight: FontWeight.w100,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Color(0xFFCDD1D0).withAlpha(51),
          ),
        ),
      ],
    );
  }
}
