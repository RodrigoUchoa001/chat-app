import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF24786D),
    scaffoldBackgroundColor: Color(0xFF121414),
    textTheme: const TextTheme(
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
