import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>(
  (ref) => LocaleNotifier(),
);

enum AppLocale { en, pt }

extension AppLocaleExtension on AppLocale {
  Locale get locale {
    switch (this) {
      case AppLocale.pt:
        return const Locale('pt', 'BR');
      case AppLocale.en:
        return const Locale('en', 'Us');
    }
  }
}

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en', 'Us')) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString('appLocale');

    if (localeCode != null) {
      state = AppLocale.values
          .firstWhere(
            (locale) => locale.name == localeCode,
            orElse: () => AppLocale.en,
          )
          .locale;
    } else {
      _detectSystemLocale();
    }
  }

  void _detectSystemLocale() {
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
    if (systemLocale.languageCode == 'pt') {
      state = AppLocale.pt.locale;
    } else {
      state = AppLocale.en.locale;
    }
  }

  Future<void> setLocale(AppLocale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('appLocale', locale.name);
    state = locale.locale;
  }
}
