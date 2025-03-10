import 'package:chatapp/features/settings/presentation/widgets/setting_button.dart';
import 'package:chatapp/gen/assets.gen.dart';
import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
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
          title: const Text(
            'Account Settings',
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
                title: "Change name",
                subtitle: "subtitle",
                onTap: () {},
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
              SettingButton(
                title: "Change name",
                subtitle: "subtitle",
                onTap: () {},
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
              SettingButton(
                title: "Change name",
                subtitle: "subtitle",
                onTap: () {},
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
}
