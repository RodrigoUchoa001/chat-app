import 'package:chatapp/core/localization/app_localization.dart';
import 'package:chatapp/core/localization/locale_provider.dart';
import 'package:chatapp/core/theme/theme_provider.dart';
import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatTextField extends ConsumerWidget {
  final Function(String text)? onChanged;
  final TextEditingController controller;
  const ChatTextField({this.onChanged, required this.controller, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    final locale = ref.watch(localeProvider);
    final localization = ref.watch(localizationProvider(locale)).value;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: themeMode == ThemeMode.light ? Colors.black : Colors.white,
            fontSize: 12,
          ),
      cursorColor: themeMode == ThemeMode.light ? Colors.black : Colors.white,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: themeMode == ThemeMode.dark ||
                (themeMode == ThemeMode.system &&
                    MediaQuery.of(context).platformBrightness ==
                        Brightness.dark)
            ? Color(0xFF192222)
            : Color(0xFFF3F6F6),
        hintText: localization?.translate("write-your-message") ?? "",
        hintStyle: TextStyle(
          color: Color(0xFF797C7B),
          fontSize: 12,
          fontFamily: FontFamily.circular,
        ),
      ),
    );
  }
}
