import 'package:chatapp/features/onboarding/presentation/widgets/login_icon_button.dart';
import 'package:chatapp/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OnBoardLoginButtonsRow extends ConsumerWidget {
  const OnBoardLoginButtonsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoginIconButton(
          iconPath: Assets.icons.facebook.path,
          onTap: () {
            Fluttertoast.showToast(msg: 'Not implemented yet!');
          },
        ),
        const SizedBox(width: 20),
        LoginIconButton(
          iconPath: Assets.icons.google.path,
          onTap: () {},
        ),
        const SizedBox(width: 20),
        LoginIconButton(
          iconPath: Assets.icons.apple.path,
          onTap: () {
            Fluttertoast.showToast(msg: 'Not implemented yet!');
          },
        ),
      ],
    );
  }
}
