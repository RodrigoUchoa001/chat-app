import 'package:chatapp/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class OnBoardLoginButtonsRow extends ConsumerWidget {
  const OnBoardLoginButtonsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFFA8B0AF),
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          width: 48,
          height: 48,
          child: SvgPicture.asset(Assets.icons.facebook.path),
        ),
        const SizedBox(width: 20),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFFA8B0AF),
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          width: 48,
          height: 48,
          child: SvgPicture.asset(Assets.icons.google.path),
        ),
        const SizedBox(width: 20),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFFA8B0AF),
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          width: 48,
          height: 48,
          child: SvgPicture.asset(Assets.icons.apple.path),
        ),
      ],
    );
  }
}
