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
            "App Settings",
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
                title: "App theme",
                subtitle: "Select your preferred theme",
                onTap: null,
                trailing: DropdownButton(
                  value: "System",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: FontFamily.caros,
                  ),
                  dropdownColor: Color(0xFF121414),
                  items: const [
                    DropdownMenuItem(
                      value: "System",
                      child: Text("System"),
                    ),
                    DropdownMenuItem(
                      value: "Light",
                      child: Text("Light"),
                    ),
                    DropdownMenuItem(
                      value: "Dark",
                      child: Text("Dark"),
                    ),
                  ],
                  onChanged: (value) {},
                ),
              ),
              SettingButton(
                title: "App language",
                subtitle: "Select your preferred language",
                onTap: null,
                trailing: DropdownButton(
                  value: "System",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: FontFamily.caros,
                  ),
                  dropdownColor: Color(0xFF121414),
                  items: const [
                    DropdownMenuItem(
                      value: "System",
                      child: Text("System"),
                    ),
                    DropdownMenuItem(
                      value: "English",
                      child: Text("English"),
                    ),
                    DropdownMenuItem(
                      value: "Português",
                      child: Text("Português"),
                    ),
                  ],
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
