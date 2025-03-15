import 'package:chatapp/core/localization/app_localization.dart';
import 'package:chatapp/core/localization/locale_provider.dart';
import 'package:chatapp/core/theme/theme_provider.dart';
import 'package:chatapp/features/chat/data/repositories/chat_repository.dart';
import 'package:chatapp/features/settings/presentation/widgets/setting_button.dart';
import 'package:chatapp/gen/assets.gen.dart';
import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class ChatSettingsScreen extends ConsumerStatefulWidget {
  const ChatSettingsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChatSettingsScreenState();
}

class _ChatSettingsScreenState extends ConsumerState<ChatSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final chatRepo = ref.watch(chatRepositoryProvider);

    final themeMode = ref.watch(themeProvider);

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
            localization?.translate("settings-chat-title") ?? "",
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
                title: localization
                        ?.translate("settings-chat-delete-all-chats-title") ??
                    "",
                subtitle: localization?.translate(
                        "settings-chat-delete-all-chats-subtitle") ??
                    "",
                onTap: () async {
                  await _showDialog(
                    () {
                      try {
                        chatRepo.deleteAllPrivateChats();
                        Fluttertoast.showToast(
                          msg: localization?.translate(
                                  "settings-chat-all-chats-deleted") ??
                              "",
                        );
                        context.pop();
                      } on Exception catch (e) {
                        Fluttertoast.showToast(msg: e.toString());
                      }
                    },
                    localization?.translate(
                            "settings-chat-delete-all-chats-title") ??
                        "",
                    localization?.translate(
                            "settings-chat-delete-all-chats-you-sure") ??
                        "",
                    localization?.translate("settings-chat-cancel") ?? "",
                    localization?.translate("settings-chat-delete") ?? "",
                  );
                },
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color:
                      themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                ),
              ),
              SettingButton(
                title: localization
                        ?.translate("settings-chat-left-all-groups-title") ??
                    "",
                subtitle: localization
                        ?.translate("settings-chat-left-all-groups-subtitle") ??
                    "",
                onTap: () async {
                  await _showDialog(
                    () {
                      try {
                        chatRepo.leftAllGroupChats();
                        Fluttertoast.showToast(
                          msg: localization?.translate(
                                  "settings-chat-all-groups-left") ??
                              "",
                        );
                        context.pop();
                      } on Exception catch (e) {
                        Fluttertoast.showToast(msg: e.toString());
                      }
                    },
                    localization?.translate(
                            "settings-chat-left-all-groups-title") ??
                        "",
                    localization?.translate(
                            "settings-chat-left-all-groups-you-sure") ??
                        "",
                    localization?.translate("settings-chat-cancel") ?? "",
                    localization?.translate("settings-chat-left") ?? "",
                  );
                },
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color:
                      themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDialog(
    Function submit,
    String title,
    String subtitle,
    String cancelText,
    String submitText,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 16,
                ),
          ),
          content: Text(
            subtitle,
            style: TextStyle(
              fontFamily: FontFamily.circular,
              color: Color(0xFF797C7B),
            ),
          ),
          actions: [
            TextButton(
              child: Text(cancelText),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(submitText),
              onPressed: () => submit(),
            ),
          ],
        );
      },
    );
  }
}
