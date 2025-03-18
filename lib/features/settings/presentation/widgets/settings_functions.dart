import 'package:chatapp/core/localization/app_localization.dart';
import 'package:chatapp/core/localization/locale_provider.dart';
import 'package:chatapp/core/providers/firebase_auth_providers.dart';
import 'package:chatapp/core/theme/theme_provider.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_profile_pic.dart';
import 'package:chatapp/features/settings/presentation/widgets/setting_button.dart';
import 'package:chatapp/features/users/data/repositories/user_repository.dart';
import 'package:chatapp/gen/assets.gen.dart';
import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsFunctions extends ConsumerStatefulWidget {
  const SettingsFunctions({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SettingsFunctionsState();
}

class _SettingsFunctionsState extends ConsumerState<SettingsFunctions> {
  @override
  Widget build(BuildContext context) {
    final userRepo = ref.watch(userRepositoryProvider);
    final currentUser = ref.watch(currentUserProvider).asData?.value;

    final themeMode = ref.watch(themeProvider);

    final locale = ref.watch(localeProvider);
    final localization = ref.watch(localizationProvider(locale)).value;

    return ListView(
      children: [
        const SizedBox(height: 41),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              ChatProfilePic(
                chatPhotoURL: currentUser?.photoURL,
                isOnline: false,
              ),
              const SizedBox(width: 15),
              StreamBuilder(
                stream: userRepo.getUserDetails(currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data!.name ?? '',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        snapshot.data!.statusMessage ?? '',
                        style: const TextStyle(
                          color: Color(0xFF797C7B),
                          fontSize: 12,
                          fontFamily: FontFamily.circular,
                        ),
                      ),
                    ],
                  );
                },
              )
            ],
          ),
        ),
        const SizedBox(height: 20),
        Divider(
            height: 1,
            color: themeMode == ThemeMode.dark ||
                    (themeMode == ThemeMode.system &&
                        MediaQuery.of(context).platformBrightness ==
                            Brightness.dark)
                ? Color(0xFF2D2F2E)
                : Color(0xFFF5F6F6)),
        const SizedBox(height: 18),
        SettingButton(
          iconPath: Assets.icons.keys.path,
          title: localization?.translate("settings-account-title") ?? "",
          subtitle: localization?.translate("settings-account-subtitle") ?? "",
          onTap: () {
            context.push('/settings/account-settings');
          },
        ),
        SettingButton(
          iconPath: Assets.icons.message.path,
          title: localization?.translate("settings-chat-title") ?? "",
          subtitle: localization?.translate("settings-chat-subtitle") ?? "",
          onTap: () {
            context.push('/settings/chat-settings');
          },
        ),
        SettingButton(
          iconPath: Assets.icons.settings.path,
          title: localization?.translate("settings-app-title") ?? "",
          subtitle: localization?.translate("settings-app-subtitle") ?? "",
          onTap: () {
            context.push('/settings/app-settings');
          },
        ),
        SettingButton(
          iconPath: Assets.icons.githubIcon.path,
          title: localization?.translate("settings-source-code-title") ?? "",
          subtitle:
              localization?.translate("settings-source-code-subtitle") ?? "",
          onTap: () {
            final Uri uri =
                Uri.parse("https://github.com/RodrigoUchoa001/chat-app");

            launchUrl(uri);
          },
        ),
        SettingButton(
          imagePath: "https://avatars.githubusercontent.com/u/85903922?v=4",
          title: localization?.translate("settings-portifolio-title") ?? "",
          subtitle:
              localization?.translate("settings-portifolio-subtitle") ?? "",
          onTap: () {
            final Uri uri = Uri.parse("https://github.com/RodrigoUchoa001");

            launchUrl(uri);
          },
        ),
      ],
    );
  }
}
