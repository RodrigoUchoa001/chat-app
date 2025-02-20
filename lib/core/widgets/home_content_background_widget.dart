import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeContentBackground extends ConsumerWidget {
  final double height;
  final Widget child;
  const HomeContentBackground(
      {required this.height, required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Color(0xFF121414),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: child,
    );
  }
}
