import 'package:chatapp/core/widgets/chat_text_button.dart';
import 'package:chatapp/features/onboarding/presentation/widgets/on_board_appbar.dart';
import 'package:chatapp/features/onboarding/presentation/widgets/on_board_divider.dart';
import 'package:chatapp/features/onboarding/presentation/widgets/on_board_existing_account.dart';
import 'package:chatapp/features/onboarding/presentation/widgets/on_board_login_buttons_row.dart';
import 'package:chatapp/features/onboarding/presentation/widgets/on_board_subtitle.dart';
import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
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
              child: ListView(
                children: [
                  const SizedBox(height: 64),
                  OnBoardAppbar(),
                  const SizedBox(height: 43.8),
                  Text(
                    'Connect friends',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 68,
                      height: 1.2,
                      fontFamily: FontFamily.caros,
                    ),
                  ),
                  Text(
                    'easily & quickly',
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
                  ChatTextButton(onTap: () {}, text: "Sign up with email"),
                  const SizedBox(height: 46),
                  OnBoardExistingAccount(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
