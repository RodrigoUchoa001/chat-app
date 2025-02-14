import 'package:chatapp/features/auth/presentation/controllers/auth_controller.dart';
import 'package:chatapp/features/auth/presentation/providers/is_loging_in_provider.dart';
import 'package:chatapp/features/auth/presentation/widgets/login_icon_button.dart';
import 'package:chatapp/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class OnBoardLoginButtonsRow extends ConsumerWidget {
  const OnBoardLoginButtonsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);

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
          onTap: () async {
            ref.read(isLogingInProvider.notifier).state = true;

            if (await auth.loginWithGoogle()) {
              Fluttertoast.showToast(msg: 'Login successful!');
              context.go('/home');
              ref.read(isLogingInProvider.notifier).state = false;
            } else {
              Fluttertoast.showToast(msg: 'Login failed!');
              ref.read(isLogingInProvider.notifier).state = false;
            }
          },
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
