import 'package:chatapp/core/widgets/chat_text_button.dart';
import 'package:chatapp/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:chatapp/features/auth/presentation/widgets/auth_subtitle.dart';
import 'package:chatapp/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:chatapp/features/auth/presentation/widgets/auth_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
            AuthTitle(
              title1: 'Sign up',
              title2: 'with Email',
              containerWidth: 68.6,
            ),
            const SizedBox(height: 17),
            AuthSubtitle(
              subtitle:
                  'Get chatting with friends and family today by signing up for our chat app!',
            ),
            const SizedBox(height: 60),
            AuthTextField(
              controller: nameController,
              labelText: 'Your name',
            ),
            const SizedBox(height: 30),
            AuthTextField(
              controller: emailController,
              labelText: 'Your email',
            ),
            const SizedBox(height: 30),
            AuthTextField(
              controller: passwordController,
              labelText: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 30),
            AuthTextField(
              controller: confirmPasswordController,
              labelText: 'Confirm Password',
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
                text: 'Create a account',
                buttonColor: Color(0xFF24786D),
                textColor: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
