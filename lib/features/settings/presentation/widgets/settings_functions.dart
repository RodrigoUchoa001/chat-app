import 'package:chatapp/core/providers/firebase_auth_providers.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_profile_pic.dart';
import 'package:chatapp/features/settings/presentation/widgets/setting_button.dart';
import 'package:chatapp/features/users/data/repositories/user_repository.dart';
import 'package:chatapp/gen/assets.gen.dart';
import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    return Column(
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: FontFamily.caros,
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
        const Divider(height: 1, color: Color(0xFF2D2F2E)),
        const SizedBox(height: 18),
        SettingButton(
          iconPath: Assets.icons.keys.path,
          title: "Account",
          subtitle: "Privacy, security, change number",
          onTap: () {},
        ),
        SettingButton(
          iconPath: Assets.icons.message.path,
          title: "Chat",
          subtitle: "Chat history,theme,wallpapers",
          onTap: () {},
        ),
        SettingButton(
          iconPath: Assets.icons.notification.path,
          title: "Notifications",
          subtitle: "Messages, group and others",
          onTap: () {},
        ),
        SettingButton(
          iconPath: Assets.icons.githubIcon.path,
          title: "See the source code",
          subtitle: "Click to see the ChatBox source code",
          onTap: () {},
        ),
        SettingButton(
          imagePath: "https://avatars.githubusercontent.com/u/85903922?v=4",
          title: "Check my portfolio",
          subtitle: "Click to see my portfolio",
          onTap: () {},
        ),
      ],
    );
  }
}
