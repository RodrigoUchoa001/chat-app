import 'package:chatapp/core/localization/app_localization.dart';
import 'package:chatapp/core/localization/locale_provider.dart';
import 'package:chatapp/core/providers/firebase_auth_providers.dart';
import 'package:chatapp/core/theme/theme_provider.dart';
import 'package:chatapp/features/auth/data/repositories/auth_repository.dart';
import 'package:chatapp/features/settings/presentation/widgets/setting_button.dart';
import 'package:chatapp/features/users/data/repositories/user_repository.dart';
import 'package:chatapp/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class AccountSettingsScreen extends ConsumerStatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends ConsumerState<AccountSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final userRepo = ref.watch(userRepositoryProvider);
    final currentUser = ref.watch(currentUserProvider).asData?.value;

    final themeMode = ref.watch(themeProvider);

    final authRepo = ref.watch(authRepositoryProvider);

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
            localization?.translate("settings-account-title") ?? "",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 20,
                ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: StreamBuilder(
            stream: userRepo.getUserDetails(currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text('Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red)));
              }

              final user = snapshot.data!;
              return ListView(
                children: [
                  SettingButton(
                    title: localization
                            ?.translate("settings-account-change-name") ??
                        "",
                    subtitle: user.name ?? "",
                    onTap: () async {
                      final newName = await showDialog(
                        context: context,
                        builder: (context) {
                          String tempName = user.name ?? "";
                          return AlertDialog(
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            title: Text(
                              localization?.translate(
                                      "settings-account-change-name") ??
                                  "",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 16,
                                  ),
                            ),
                            content: TextField(
                              onChanged: (value) {
                                tempName = value;
                              },
                              controller: TextEditingController(text: tempName),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: themeMode == ThemeMode.dark ||
                                              (themeMode == ThemeMode.system &&
                                                  MediaQuery.of(context)
                                                          .platformBrightness ==
                                                      Brightness.dark)
                                          ? Colors.white
                                          : Colors.black),
                              decoration: InputDecoration(
                                labelText: localization?.translate(
                                        "settings-account-change-name-placeholder") ??
                                    "",
                                labelStyle:
                                    Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: Text(
                                  localization?.translate(
                                          "settings-account-cancel") ??
                                      "",
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              FilledButton(
                                child: Text(
                                  localization?.translate(
                                          "settings-account-save") ??
                                      "",
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop(tempName);
                                },
                              ),
                            ],
                          );
                        },
                      );

                      if (newName != null && newName.isNotEmpty) {
                        try {
                          await userRepo.updateUserName(name: newName);
                          Fluttertoast.showToast(
                              msg: localization?.translate(
                                      "settings-account-name-updated") ??
                                  "");
                        } on Exception catch (e) {
                          Fluttertoast.showToast(msg: e.toString());
                        }
                      }
                    },
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: themeMode == ThemeMode.dark ||
                              (themeMode == ThemeMode.system &&
                                  MediaQuery.of(context).platformBrightness ==
                                      Brightness.dark)
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  SettingButton(
                    title: localization
                            ?.translate("settings-account-change-status") ??
                        "",
                    subtitle: user.statusMessage ?? "",
                    onTap: () async {
                      final newStatus = await showDialog(
                        context: context,
                        builder: (context) {
                          String tempStatus = user.statusMessage ?? "";
                          return AlertDialog(
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            title: Text(
                              localization?.translate(
                                      "settings-account-change-status") ??
                                  "",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 16,
                                  ),
                            ),
                            content: TextField(
                              onChanged: (value) {
                                tempStatus = value;
                              },
                              controller:
                                  TextEditingController(text: tempStatus),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: themeMode == ThemeMode.dark ||
                                              (themeMode == ThemeMode.system &&
                                                  MediaQuery.of(context)
                                                          .platformBrightness ==
                                                      Brightness.dark)
                                          ? Colors.white
                                          : Colors.black),
                              decoration: InputDecoration(
                                labelText: localization?.translate(
                                        "settings-account-change-status-placeholder") ??
                                    "",
                                labelStyle:
                                    Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: Text(localization?.translate(
                                        "settings-account-cancel") ??
                                    ""),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              FilledButton(
                                child: Text(localization
                                        ?.translate("settings-account-save") ??
                                    ""),
                                onPressed: () {
                                  Navigator.of(context).pop(tempStatus);
                                },
                              ),
                            ],
                          );
                        },
                      );

                      if (newStatus != null && newStatus.isNotEmpty) {
                        try {
                          await userRepo.updateUserStatusMessage(
                              statusMessage: newStatus);
                          Fluttertoast.showToast(
                              msg: localization?.translate(
                                      "settings-account-status-updated") ??
                                  "");
                        } on Exception catch (e) {
                          Fluttertoast.showToast(msg: e.toString());
                        }
                      }
                    },
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: themeMode == ThemeMode.dark ||
                              (themeMode == ThemeMode.system &&
                                  MediaQuery.of(context).platformBrightness ==
                                      Brightness.dark)
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      color: Color(0xFFEA3736).withAlpha(100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: SettingButton(
                        title: localization?.translate(
                                "settings-account-sign-out-title") ??
                            "",
                        subtitle: localization?.translate(
                                "settings-account-sign-out-subtitle") ??
                            "",
                        onTap: () async {
                          try {
                            await authRepo.logout();
                            context.go("/onboarding");
                          } on Exception catch (e) {
                            Fluttertoast.showToast(msg: "Error: $e");
                          }
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
