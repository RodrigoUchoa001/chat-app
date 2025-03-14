import 'package:chatapp/core/localization/app_localization.dart';
import 'package:chatapp/core/localization/locale_provider.dart';
import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnBoardExistingAccount extends ConsumerWidget {
  const OnBoardExistingAccount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final localization = ref.watch(localizationProvider(locale)).value;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          localization?.translate("onboarding-existing-account") ?? "",
          style: TextStyle(
            color: Color(0xFFB9C1BE),
            fontSize: 16,
            fontFamily: FontFamily.circular,
            fontWeight: FontWeight.normal,
          ),
        ),
        GestureDetector(
          onTap: () {
            context.push('/login');
          },
          child: Text(
            localization?.translate("onboarding-login-text") ?? "",
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
