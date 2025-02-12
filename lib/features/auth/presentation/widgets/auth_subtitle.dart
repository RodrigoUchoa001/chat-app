import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthSubtitle extends ConsumerWidget {
  final String subtitle;
  const AuthSubtitle({required this.subtitle, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Text(
      'Welcome back! Sign in using your social account or email to continue with us.',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xFF797C7B),
        fontFamily: FontFamily.circular,
        fontSize: 14,
      ),
    );
  }
}
