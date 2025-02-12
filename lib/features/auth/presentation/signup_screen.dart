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

  String? _textValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field cannot be empty.';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field cannot be empty.';
    }
    if (!EmailValidator.validate(value)) {
      return 'Invalid email address.';
    }
    return null;
  }

  void _validate() async {
    if (_formKey.currentState!.validate()) {
      final auth = ref.read(authControllerProvider);

      final errorMessage = await auth.registerWithEmailAndPassword(
        nameController.text,
        emailController.text,
        passwordController.text,
      );

      if (errorMessage == null) {
        Fluttertoast.showToast(msg: 'Login successful!');
      } else {
        Fluttertoast.showToast(msg: 'Error signing up!');
      }
    }
  }

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
        child: Form(
          key: _formKey,
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
                validator: _textValidator,
              ),
              const SizedBox(height: 30),
              AuthTextField(
                controller: emailController,
                labelText: 'Your email',
                validator: _emailValidator,
              ),
              const SizedBox(height: 30),
              AuthTextField(
                controller: passwordController,
                labelText: 'Password',
                validator: _textValidator,
                obscureText: true,
              ),
              const SizedBox(height: 30),
              AuthTextField(
                controller: confirmPasswordController,
                labelText: 'Confirm Password',
                validator: _textValidator,
                obscureText: true,
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
                onTap: () => _validate(),
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
