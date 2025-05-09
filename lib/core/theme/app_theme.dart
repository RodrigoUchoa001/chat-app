import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF24786D),
    canvasColor: Color(0xFF000E08),
    scaffoldBackgroundColor: Colors.white,
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStatePropertyAll(Color(0xFF000E08)),
      ),
    ),
    cardColor: const Color(0xFFF2F8F7),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Colors.white,
        fontFamily: FontFamily.caros,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFF000E08),
        fontFamily: FontFamily.caros,
      ),
      bodySmall: TextStyle(
        color: Color(0xFF797C7B),
        fontFamily: FontFamily.circular,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF24786D),
    canvasColor: Color(0xFF24786D),
    scaffoldBackgroundColor: Color(0xFF121414),
    cardColor: const Color(0xFF1D2525),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStatePropertyAll(Colors.white),
      ),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Colors.white,
        fontFamily: FontFamily.caros,
      ),
      bodyMedium: TextStyle(
        color: Colors.white,
        fontFamily: FontFamily.caros,
      ),
      bodySmall: TextStyle(
        color: Color(0xFF797C7B),
        fontFamily: FontFamily.circular,
      ),
    ),
  );
}
