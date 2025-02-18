import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class ChatIconButton extends ConsumerWidget {
  final String iconPath;
  const ChatIconButton({required this.iconPath, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () {},
      icon: SvgPicture.asset(
        iconPath,
        height: 24,
      ),
    );
  }
}
