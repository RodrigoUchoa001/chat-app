import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnBoardTitle extends ConsumerWidget {
  const OnBoardTitle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        Text(
          'Connect friends',
          style: TextStyle(
            color: Colors.white,
            fontSize: 68,
            height: 1.2,
            fontFamily: FontFamily.caros,
          ),
        ),
        Text(
          'easily & quickly',
          style: TextStyle(
            color: Colors.white,
            fontSize: 68,
            height: 1.2,
            fontFamily: FontFamily.caros,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
