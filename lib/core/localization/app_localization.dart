import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/gen/assets.gen.dart';

final localizationProvider =
    FutureProvider.family<AppLocalization, Locale>((ref, locale) async {
  final localization = AppLocalization(locale);
  await localization.load();
  return localization;
});

class AppLocalization {
  final Locale locale;
  late Map<String, String> _localizedStrings;

  AppLocalization(this.locale);

  Future<void> load() async {
    final jsonString = await rootBundle.loadString(_getLocalePath());
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  String _getLocalePath() {
    switch (locale.languageCode) {
      case 'pt':
        return Assets.lang.ptBr;
      case 'en':
      default:
        return Assets.lang.en;
    }
  }
}
