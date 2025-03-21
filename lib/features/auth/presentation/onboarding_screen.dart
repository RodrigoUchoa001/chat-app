import 'package:chatapp/core/localization/app_localization.dart';
import 'package:chatapp/core/localization/locale_provider.dart';
import 'package:chatapp/core/widgets/chat_text_button.dart';
import 'package:chatapp/features/auth/presentation/providers/is_loging_in_provider.dart';
import 'package:chatapp/features/auth/presentation/widgets/language_switch.dart';
import 'package:chatapp/features/auth/presentation/widgets/on_board_appbar.dart';
import 'package:chatapp/features/auth/presentation/widgets/on_board_divider.dart';
import 'package:chatapp/features/auth/presentation/widgets/on_board_existing_account.dart';
import 'package:chatapp/features/auth/presentation/widgets/on_board_login_buttons_row.dart';
import 'package:chatapp/features/auth/presentation/widgets/on_board_subtitle.dart';
import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    final isLogingIn = ref.watch(isLogingInProvider);
    final locale = ref.watch(localeProvider);
    final localization = ref.watch(localizationProvider(locale)).value;

    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -200,
              left: -100,
              child: Image(
                image: AssetImage('assets/background/elipse.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 64),
                          OnBoardAppbar(),
                          const SizedBox(height: 43.8),
                          Text(
                            localization?.translate("onboarding-title1") ?? "",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 68,
                              height: 1.2,
                              fontFamily: FontFamily.caros,
                            ),
                          ),
                          Text(
                            localization?.translate("onboarding-title2") ?? "",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 68,
                              height: 1.2,
                              fontFamily: FontFamily.caros,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          OnBoardSubtitle(),
                          const SizedBox(height: 38),
                          OnBoardLoginButtonsRow(),
                          const SizedBox(height: 20),
                          OnBoardDivider(),
                          const SizedBox(height: 20),
                          ChatTextButton(
                            onTap: isLogingIn
                                ? null
                                : () => context.push('/signup'),
                            text: isLogingIn
                                ? localization
                                        ?.translate("signing-in-button-text") ??
                                    ""
                                : localization
                                        ?.translate("sign-in-button-text") ??
                                    "",
                            buttonColor: Colors.white,
                            textColor: Colors.black,
                          ),
                          const SizedBox(height: 20),
                          OnBoardExistingAccount(),
                          const SizedBox(height: 46),
                        ],
                      ),
                    ),
                  ),
                  LanguageSwitch(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
