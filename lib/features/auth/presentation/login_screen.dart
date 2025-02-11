import 'package:chatapp/core/widgets/chat_text_button.dart';
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
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 30),
        child: ListView(
          children: [
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Container(
                      height: 8,
                      width:
                          61.1, //change accordingly to the size of the text below
                      decoration: BoxDecoration(
                        color: Color(0xFF58C3b6),
                      ),
                    ),
                    const Text(
                      'Log in ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: FontFamily.caros,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Text(
                  ' to Chatbox',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: FontFamily.caros,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Welcome back! Sign in using your social account or email to continue with us',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF797C7B),
                fontFamily: FontFamily.circular,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 30),
            OnBoardLoginButtonsRow(),
            const SizedBox(height: 30),
            OnBoardDivider(),
            const SizedBox(height: 30),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Your email',
                labelStyle: TextStyle(
                  color: Color(0xFF5EBAAE),
                  fontFamily: FontFamily.circular,
                  fontSize: 14,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF595E5C)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF5EBAAE)),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF595E5C)),
                ),
              ),
              style: TextStyle(
                color: Colors.white,
                fontFamily: FontFamily.caros,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                  color: Color(0xFF5EBAAE),
                  fontFamily: FontFamily.circular,
                  fontSize: 14,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF595E5C)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF5EBAAE)),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF595E5C)),
                ),
              ),
              style: TextStyle(
                color: Colors.white,
                fontFamily: FontFamily.caros,
                fontSize: 16,
              ),
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
