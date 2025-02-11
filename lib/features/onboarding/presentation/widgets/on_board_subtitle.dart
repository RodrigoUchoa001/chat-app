import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnBoardSubtitle extends ConsumerWidget {
  const OnBoardSubtitle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      'Our chat app is the perfect way to stay connected with your friends and family.',
      style: TextStyle(
        color: Color(0xFFB9C1BE),
        fontSize: 16,
        fontFamily: FontFamily.circular,
        fontWeight: FontWeight.w100,
      ),
    );
  }
}
