import 'package:chatapp/core/localization/app_localization.dart';
import 'package:chatapp/core/localization/locale_provider.dart';
import 'package:chatapp/core/widgets/chat_text_button.dart';
import 'package:chatapp/features/auth/presentation/controllers/auth_controller.dart';
import 'package:chatapp/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:chatapp/features/auth/presentation/widgets/auth_subtitle.dart';
import 'package:chatapp/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:chatapp/features/auth/presentation/widgets/auth_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

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

  final _formKey = GlobalKey<FormState>();

  void _validate() async {
    if (_formKey.currentState!.validate()) {
      final auth = ref.read(authControllerProvider);

      if (passwordController.text != confirmPasswordController.text) {
        Fluttertoast.showToast(msg: 'Passwords do not match.');
        return;
      }

      final errorMessage = await auth.registerWithEmailAndPassword(
        nameController.text,
        emailController.text,
        passwordController.text,
      );

      if (errorMessage == null) {
        Fluttertoast.showToast(msg: 'Signup successful!');
        context.go('/home');
      } else {
        Fluttertoast.showToast(msg: errorMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final localization = ref.watch(localizationProvider(locale)).value;

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
                child: ListView(
                  children: [
                    AuthTitle(
                      title1: localization?.translate("sign-up-title1") ?? "",
                      title2: localization?.translate("sign-up-title2") ?? "",
                      containerWidth: 68.6,
                    ),
                    const SizedBox(height: 17),
                    AuthSubtitle(
                      subtitle:
                          localization?.translate("sign-up-subtitle") ?? "",
                    ),
                    const SizedBox(height: 60),
                    AuthTextField(
                      controller: nameController,
                      labelText: localization?.translate("sign-up-name") ?? "",
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return localization
                                  ?.translate("sign-up-empty-field") ??
                              "";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    AuthTextField(
                        controller: emailController,
                        labelText:
                            localization?.translate("sign-up-email") ?? "",
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return localization
                                    ?.translate("sign-up-empty-field") ??
                                "";
                          }
                          if (!EmailValidator.validate(value)) {
                            return localization
                                    ?.translate("sign-up-invalid-email") ??
                                "";
                          }
                          return null;
                        }),
                    const SizedBox(height: 30),
                    AuthTextField(
                      controller: passwordController,
                      labelText:
                          localization?.translate("sign-up-password") ?? "",
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return localization
                                  ?.translate("sign-up-empty-field") ??
                              "";
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                    const SizedBox(height: 30),
                    AuthTextField(
                      controller: confirmPasswordController,
                      labelText:
                          localization?.translate("sign-up-confirm-password") ??
                              "",
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return localization
                                  ?.translate("sign-up-empty-field") ??
                              "";
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                  ],
                ),
              ),
            ),
            ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ChatTextButton(
                    onTap: () => _validate(),
                    text: localization?.translate("sign-up-button-text") ?? "",
                    buttonColor: Color(0xFF24786D),
                    textColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
