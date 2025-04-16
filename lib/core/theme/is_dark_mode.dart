import 'package:chatapp/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// the function returns true even if the app is in system dark mode
bool isDarkMode(WidgetRef ref, BuildContext context) {
  final themeMode = ref.watch(themeProvider);

  return themeMode == ThemeMode.dark ||
      (themeMode == ThemeMode.system &&
          MediaQuery.of(context).platformBrightness == Brightness.dark);
}
