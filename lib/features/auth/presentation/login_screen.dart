import 'package:chatapp/core/widgets/chat_text_button.dart';
import 'package:chatapp/features/auth/presentation/controllers/auth_controller.dart';
import 'package:chatapp/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:chatapp/features/auth/presentation/widgets/auth_subtitle.dart';
import 'package:chatapp/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:chatapp/features/auth/presentation/widgets/auth_title.dart';
import 'package:chatapp/features/onboarding/presentation/providers/is_loging_in_provider.dart';
import 'package:chatapp/features/onboarding/presentation/widgets/on_board_divider.dart';
import 'package:chatapp/features/onboarding/presentation/widgets/on_board_login_buttons_row.dart';
import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? _validator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field cannot be empty.';
    }
    return null;
  }

  void _validate() async {
    ref.read(isLogingInProvider.notifier).state = true;

    if (_formKey.currentState!.validate()) {
      final auth = ref.read(authControllerProvider);

      final errorMessage = await auth.loginWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );

      if (errorMessage == null) {
        Fluttertoast.showToast(msg: 'Login successful!');
        // TODO: implement context.go to home screen
        ref.read(isLogingInProvider.notifier).state = false;
      } else {
        Fluttertoast.showToast(msg: errorMessage);
        ref.read(isLogingInProvider.notifier).state = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLogingIn = ref.watch(isLogingInProvider);

    return Scaffold(
      backgroundColor: Color(0xFF121414),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: AuthBackButton(),
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
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
                validator: _validator,
              ),
              const SizedBox(height: 30),
              AuthTextField(
                controller: passwordController,
                labelText: 'Password',
                obscureText: true,
                validator: _validator,
              ),
            ],
          ),
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
                onTap: isLogingIn ? null : () => _validate(),
                text: isLogingIn ? 'Logging in...' : 'Log in',
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
                GestureDetector(
                  onTap: () => context.push('/signup'),
                  child: const Text(
                    ' Sign up.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF5EBAAE),
                      fontFamily: FontFamily.circular,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
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
