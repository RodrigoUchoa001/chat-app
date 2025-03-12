import 'package:chatapp/core/theme/theme_provider.dart';
import 'package:chatapp/core/widgets/chat_text_button.dart';
import 'package:chatapp/features/auth/presentation/controllers/auth_controller.dart';
import 'package:chatapp/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:chatapp/features/auth/presentation/widgets/auth_subtitle.dart';
import 'package:chatapp/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:chatapp/features/auth/presentation/widgets/auth_title.dart';
import 'package:chatapp/features/auth/presentation/providers/is_loging_in_provider.dart';
import 'package:chatapp/features/auth/presentation/widgets/login_icon_button.dart';
import 'package:chatapp/features/auth/presentation/widgets/on_board_divider.dart';
import 'package:chatapp/features/auth/presentation/widgets/on_board_login_buttons_row.dart';
import 'package:chatapp/gen/assets.gen.dart';
import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
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
    if (_formKey.currentState!.validate()) {
      ref.read(isLogingInProvider.notifier).state = true;

      final auth = ref.read(authControllerProvider);

      final errorMessage = await auth.loginWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );

      if (errorMessage == null) {
        Fluttertoast.showToast(msg: 'Login successful!');
        context.go('/home');

        ref.read(isLogingInProvider.notifier).state = false;
      } else {
        Fluttertoast.showToast(msg: errorMessage);
        ref.read(isLogingInProvider.notifier).state = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final isLogingIn = ref.watch(isLogingInProvider);

    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: AuthBackButton(),
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LoginIconButton(
                            iconPath: Assets.icons.facebook.path,
                            onTap: () {
                              Fluttertoast.showToast(
                                  msg: 'Not implemented yet!');
                            },
                          ),
                          const SizedBox(width: 20),
                          LoginIconButton(
                            iconPath: Assets.icons.google.path,
                            onTap: () async {
                              ref.read(isLogingInProvider.notifier).state =
                                  true;

                              if (await auth.loginWithGoogle()) {
                                Fluttertoast.showToast(
                                    msg: 'Login successful!');
                                // exception here trying the user online thing
                                context.go('/home');
                                ref.read(isLogingInProvider.notifier).state =
                                    false;
                              } else {
                                Fluttertoast.showToast(msg: 'Login failed!');
                                ref.read(isLogingInProvider.notifier).state =
                                    false;
                              }
                            },
                          ),
                          const SizedBox(width: 20),
                          InkWell(
                            borderRadius: BorderRadius.circular(50),
                            splashColor: Color(0xFF24786D).withAlpha(150),
                            onTap: () {
                              Fluttertoast.showToast(
                                  msg: 'Not implemented yet!');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xFFA8B0AF),
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              width: 48,
                              height: 48,
                              child: SvgPicture.asset(
                                Assets.icons.apple.path,
                                colorFilter: ColorFilter.mode(
                                  themeMode == ThemeMode.light
                                      ? Colors.black
                                      : Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
            ),
            Container(
              color: Colors.transparent,
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
                      Text(
                        "Don't have account? ",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
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
          ],
        ),
      ),
    );
  }
}
