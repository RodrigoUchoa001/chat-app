import 'package:chatapp/core/widgets/chat_text_button.dart';
import 'package:chatapp/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:chatapp/features/auth/presentation/widgets/auth_subtitle.dart';
import 'package:chatapp/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:chatapp/features/auth/presentation/widgets/auth_title.dart';
import 'package:chatapp/features/onboarding/presentation/widgets/on_board_divider.dart';
import 'package:chatapp/features/onboarding/presentation/widgets/on_board_login_buttons_row.dart';
import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121414),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: AuthBackButton(),
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 30),
        child: ListView(
          children: [
            const SizedBox(height: 60),
            AuthTitle(
              title1: 'Log in',
              title2: 'to Chatbox',
              containerWidth: 55.5,
            ),
            const SizedBox(height: 16),
            AuthSubtitle(
              subtitle:
                  'Welcome back! Sign in using your social account or email to continue with us.',
            ),
            const SizedBox(height: 30),
            OnBoardLoginButtonsRow(),
            const SizedBox(height: 30),
            OnBoardDivider(),
            const SizedBox(height: 30),
            AuthTextField(
              controller: emailController,
              labelText: 'Email',
            ),
            const SizedBox(height: 30),
            AuthTextField(
              controller: passwordController,
              labelText: 'Password',
              obscureText: true,
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: Color(0xFF121414),
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ChatTextButton(
                onTap: () {},
                text: 'Log in',
                buttonColor: Color(0xFF24786D),
                textColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have account? ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: FontFamily.circular,
                    fontSize: 14,
                  ),
                ),
                const Text(
                  ' Sign up.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF5EBAAE),
                    fontFamily: FontFamily.circular,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
