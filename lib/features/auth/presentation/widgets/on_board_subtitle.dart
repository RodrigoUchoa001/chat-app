import 'package:chatapp/core/localization/app_localization.dart';
import 'package:chatapp/core/localization/locale_provider.dart';
import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnBoardSubtitle extends ConsumerWidget {
  const OnBoardSubtitle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final localization = ref.watch(localizationProvider(locale)).value;

    return Text(
      localization?.translate("onboarding-subtitle") ?? "",
      style: TextStyle(
        color: Color(0xFFB9C1BE),
        fontSize: 16,
        fontFamily: FontFamily.circular,
        fontWeight: FontWeight.w100,
      ),
    );
  }
}
