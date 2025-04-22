import 'package:chatapp/core/localization/app_localization.dart';
import 'package:chatapp/core/localization/locale_provider.dart';
import 'package:chatapp/core/providers/firebase_auth_providers.dart';
import 'package:chatapp/features/auth/data/dto/user_dto.dart';
import 'package:chatapp/features/auth/data/repositories/auth_repository.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_text_field.dart';
import 'package:chatapp/features/settings/presentation/widgets/setting_button.dart';
import 'package:chatapp/features/users/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class UserDetails extends ConsumerStatefulWidget {
  final UserDTO user;
  const UserDetails({required this.user, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserDetailsState();
}

class _UserDetailsState extends ConsumerState<UserDetails> {
  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final localization = ref.watch(localizationProvider(locale)).value;

    final authRepo = ref.watch(authRepositoryProvider);

    final currentUser = ref.watch(currentUserProvider).value;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 41 - 15), // -15 for the top padding
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: currentUser!.uid == widget.user.uid
                  ? () {
                      _buildBottomModalSheet("name", widget.user.name ?? "");
                    }
                  : null,
              child: _buildUserDetail(
                localization?.translate("user-details-display-name") ?? "",
                widget.user.name,
                isEditable: currentUser.uid == widget.user.uid,
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: currentUser!.uid == widget.user.uid
                  ? () {
                      _buildBottomModalSheet(
                          "status", widget.user.statusMessage ?? "");
                    }
                  : null,
              child: _buildUserDetail(
                localization?.translate("user-details-status-message") ?? "",
                widget.user.statusMessage,
                isEditable: currentUser.uid == widget.user.uid,
              ),
            ),
          ),
          _buildUserDetail(
            localization?.translate("user-details-email-address") ?? "",
            widget.user.email,
          ),
          _buildUserDetail(
            localization?.translate("user-details-joined-at") ?? "",
            DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(widget.user.createdAt!)),
          ),
          const SizedBox(height: 32),
          currentUser.uid == widget.user.uid
              ? Material(
                  color: Color(0xFFEA3736).withAlpha(100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: SettingButton(
                    title: localization
                            ?.translate("settings-account-sign-out-title") ??
                        "",
                    subtitle: localization
                            ?.translate("settings-account-sign-out-subtitle") ??
                        "",
                    subtitleStyle:
                        Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontSize: 12,
                              color: Colors.white.withAlpha(150),
                            ),
                    onTap: () async {
                      try {
                        await authRepo.logout();
                        context.go("/onboarding");
                      } on Exception catch (e) {
                        Fluttertoast.showToast(msg: "Error: $e");
                      }
                    },
                  ),
                )
              : Container(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildUserDetail(String title, String? value,
      {bool isEditable = false}) {
    final currentUser = ref.watch(currentUserProvider).value;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: 14,
                ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                value ?? "",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 18,
                    ),
              ),
              const SizedBox(
                width: 10,
              ),
              if (currentUser!.uid == widget.user.uid && isEditable)
                const Icon(
                  Icons.edit,
                  size: 16,
                )
            ],
          )
        ],
      ),
    );
  }

  void _buildBottomModalSheet(String infoToChange, String currentValue) {
    final userRepo = ref.watch(userRepositoryProvider);

    final controller = TextEditingController();
    controller.text = currentValue;

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                infoToChange == "name" ? "Edit name" : "Edit status message",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 18,
                    ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ChatTextField(
                  hintText: infoToChange == "name"
                      ? "Type your name"
                      : "Type your status message",
                  controller: controller,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 40,
                      child: FilledButton(
                        onPressed: () {
                          try {
                            if (infoToChange == "name") {
                              userRepo.updateUserName(name: controller.text);
                            } else {
                              userRepo.updateUserStatusMessage(
                                  statusMessage: controller.text);
                            }
                            context.pop();
                            Fluttertoast.showToast(msg: "Changes saved");
                          } on Exception catch (e) {
                            Fluttertoast.showToast(msg: "Error: $e");
                          }
                        },
                        child: Text("Save changes"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 40,
                      child: TextButton(
                        onPressed: () => context.pop(),
                        child: Text("Cancel"),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
