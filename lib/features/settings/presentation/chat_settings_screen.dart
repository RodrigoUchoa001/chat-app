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

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF121414),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: SvgPicture.asset(
              Assets.icons.backButton.path,
            ),
            onPressed: () => context.pop(),
          ),
          centerTitle: true,
          title: Text(
            "Chat Settings",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: FontFamily.caros,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ListView(
            children: [
              SettingButton(
                title: "Delete all private chats",
                subtitle: "This can't be undone",
                onTap: () async {
                  await _showDialog(
                    () {
                      try {
                        chatRepo.deleteAllPrivateChats();
                        Fluttertoast.showToast(
                            msg: "Deleted all private chats");
                        context.pop();
                      } on Exception catch (e) {
                        Fluttertoast.showToast(msg: e.toString());
                      }
                    },
                    "Delete all private chats",
                    "You sure you want to delete all private chats? This can't be undone.",
                    "Cancel",
                    "Delete",
                  );
                },
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
              SettingButton(
                title: "Left all groups",
                subtitle: "This can't be undone",
                onTap: () async {
                  await _showDialog(
                    () {
                      try {
                        chatRepo.leftAllGroupChats();
                        Fluttertoast.showToast(msg: "Left all groups");
                        context.pop();
                      } on Exception catch (e) {
                        Fluttertoast.showToast(msg: e.toString());
                      }
                    },
                    "Left all groups",
                    "You sure you want to left all groups? This can't be undone.",
                    "Cancel",
                    "Left",
                  );
                },
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
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
          backgroundColor: Color(0xFF121414),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontFamily: FontFamily.caros,
              color: Colors.white,
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
