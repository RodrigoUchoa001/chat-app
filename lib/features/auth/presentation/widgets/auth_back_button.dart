import 'package:chatapp/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class AuthBackButton extends ConsumerWidget {
  const AuthBackButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return context.canPop()
        ? IconButton(
            onPressed: () => context.pop(),
            icon: SvgPicture.asset(
              Assets.icons.backButton.path,
              width: 8,
              height: 12,
            ),
          )
        : SizedBox();
  }
}
