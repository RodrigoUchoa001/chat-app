import 'package:chatapp/core/localization/app_localization.dart';
import 'package:chatapp/core/localization/locale_provider.dart';
import 'package:chatapp/core/theme/theme_provider.dart';
import 'package:chatapp/features/settings/presentation/widgets/setting_button.dart';
import 'package:chatapp/gen/assets.gen.dart';
import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class AppSettingsScreen extends ConsumerStatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AppSettingsScreenState();
}

class _AppSettingsScreenState extends ConsumerState<AppSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = ref.read(themeProvider.notifier);
    final themeMode = ref.watch(themeProvider);
    final localeNotifier = ref.read(localeProvider.notifier);
    final locale = ref.watch(localeProvider);
    final localization = ref.watch(localizationProvider(locale)).value;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: SvgPicture.asset(
              Assets.icons.backButton.path,
              colorFilter: ColorFilter.mode(
                themeMode == ThemeMode.light ? Colors.black : Colors.white,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () => context.pop(),
          ),
          centerTitle: true,
          title: Text(
            localization?.translate("settings-app-title") ?? "",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 20,
                ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ListView(
            children: [
              SettingButton(
                title:
                    localization?.translate("settings-app-theme-title") ?? "",
                subtitle:
                    localization?.translate("settings-app-theme-subtitle") ??
                        "",
                onTap: null,
                trailing: DropdownButton(
                  value: _getThemePreference(themeMode),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: FontFamily.caros,
                  ),
                  dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                  onChanged: (value) {
                    if (value != null) {
                      themeNotifier.setTheme(value);
                    }
                  },
                  items: [
                    DropdownMenuItem(
                      value: ThemePreference.system,
                      child: Text(
                          localization
                                  ?.translate("settings-app-theme-system") ??
                              "",
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                    DropdownMenuItem(
                      value: ThemePreference.light,
                      child: Text(
                          localization?.translate("settings-app-theme-light") ??
                              "",
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                    DropdownMenuItem(
                      value: ThemePreference.dark,
                      child: Text(
                          localization?.translate("settings-app-theme-dark") ??
                              "",
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                  ],
                ),
              ),
              SettingButton(
                title: localization?.translate("settings-app-language-title") ??
                    "",
                subtitle:
                    localization?.translate("settings-app-language-subtitle") ??
                        "",
                onTap: null,
                trailing: DropdownButton(
                  value: _getAppLocale(locale),
                  onChanged: (value) {
                    if (value != null) {
                      localeNotifier.setLocale(value);
                    }
                  },
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: FontFamily.caros,
                  ),
                  dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                  items: [
                    DropdownMenuItem(
                      value: AppLocale.en,
                      child: Text(
                          localization?.translate(
                                  "settings-app-language-english") ??
                              "",
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                    DropdownMenuItem(
                      value: AppLocale.pt,
                      child: Text(
                          localization?.translate(
                                  "settings-app-language-portuguese") ??
                              "",
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ThemePreference _getThemePreference(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return ThemePreference.light;
      case ThemeMode.dark:
        return ThemePreference.dark;
      case ThemeMode.system:
        return ThemePreference.system;
    }
  }

  AppLocale _getAppLocale(Locale locale) {
    return locale.languageCode == 'pt' ? AppLocale.pt : AppLocale.en;
  }
}
