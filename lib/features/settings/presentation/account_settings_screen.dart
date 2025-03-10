import 'package:chatapp/core/providers/firebase_auth_providers.dart';
import 'package:chatapp/features/settings/presentation/widgets/setting_button.dart';
import 'package:chatapp/features/users/data/repositories/user_repository.dart';
import 'package:chatapp/gen/assets.gen.dart';
import 'package:chatapp/gen/fonts.gen.dart';
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
            "Account Settings",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: FontFamily.caros,
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
                    title: "Change name",
                    subtitle: user.name ?? "",
                    onTap: () async {
                      final newName = await showDialog(
                        context: context,
                        builder: (context) {
                          String tempName = user.name ?? "";
                          return AlertDialog(
                            backgroundColor: Color(0xFF121414),
                            title: const Text(
                              "Change Name",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: FontFamily.caros,
                                color: Colors.white,
                              ),
                            ),
                            content: TextField(
                              onChanged: (value) {
                                tempName = value;
                              },
                              controller: TextEditingController(text: tempName),
                              style: TextStyle(
                                fontFamily: FontFamily.circular,
                                color: Colors.white,
                              ),
                              decoration: const InputDecoration(
                                labelText: "Enter new name",
                                labelStyle: TextStyle(
                                  fontFamily: FontFamily.circular,
                                  color: Color(0xFF797C7B),
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: const Text("Cancel"),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              FilledButton(
                                child: const Text("Save"),
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
                          Fluttertoast.showToast(msg: "Name updated");
                        } on Exception catch (e) {
                          Fluttertoast.showToast(msg: e.toString());
                        }
                      }
                    },
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  ),
                  SettingButton(
                    title: "Change status message",
                    subtitle: user.statusMessage ?? "",
                    onTap: () async {
                      final newStatus = await showDialog(
                        context: context,
                        builder: (context) {
                          String tempStatus = user.statusMessage ?? "";
                          return AlertDialog(
                            backgroundColor: Color(0xFF121414),
                            title: const Text(
                              "Change status message",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: FontFamily.caros,
                                color: Colors.white,
                              ),
                            ),
                            content: TextField(
                              onChanged: (value) {
                                tempStatus = value;
                              },
                              controller:
                                  TextEditingController(text: tempStatus),
                              style: TextStyle(
                                fontFamily: FontFamily.circular,
                                color: Colors.white,
                              ),
                              decoration: const InputDecoration(
                                labelText: "Enter new status message",
                                labelStyle: TextStyle(
                                  fontFamily: FontFamily.circular,
                                  color: Color(0xFF797C7B),
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: const Text("Cancel"),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              FilledButton(
                                child: const Text("Save"),
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
                          Fluttertoast.showToast(msg: "Status updated");
                        } on Exception catch (e) {
                          Fluttertoast.showToast(msg: e.toString());
                        }
                      }
                    },
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
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
