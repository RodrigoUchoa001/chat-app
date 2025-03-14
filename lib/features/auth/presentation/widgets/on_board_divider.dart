import 'package:chatapp/core/localization/app_localization.dart';
import 'package:chatapp/core/localization/locale_provider.dart';
import 'package:chatapp/core/theme/theme_provider.dart';
import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnBoardDivider extends ConsumerWidget {
  const OnBoardDivider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    final locale = ref.watch(localeProvider);
    final localization = ref.watch(localizationProvider(locale)).value;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            color: Color(0xFFCDD1D0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: Text(
            localization?.translate("or") ?? "",
            style: TextStyle(
              color: themeMode == ThemeMode.light
                  ? Color(0xFF797C7B)
                  : Color(0xFFD6E4E0),
              fontSize: 14,
              fontFamily: FontFamily.circular,
              fontWeight: FontWeight.w100,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Color(0xFFCDD1D0),
          ),
        ),
      ],
    );
  }
}
