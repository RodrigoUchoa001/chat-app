import 'package:chatapp/gen/assets.gen.dart';
import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

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
      backgroundColor: Color(0xFF201c1c),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        Assets.icons.logoForBlackBack.path,
                        width: 16,
                        height: 19.2,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'ChatBox',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: FontFamily.circular,
                        ),
                      ),
                    ],
                  ),
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
                  Text(
                    'Our chat app is the perfect way to stay connected with your friends and family.',
                    style: TextStyle(
                      color: Color(0xFFB9C1BE),
                      fontSize: 16,
                      fontFamily: FontFamily.circular,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  const SizedBox(height: 38),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFFA8B0AF),
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        width: 48,
                        height: 48,
                        child: SvgPicture.asset(Assets.icons.facebook.path),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFFA8B0AF),
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        width: 48,
                        height: 48,
                        child: SvgPicture.asset(Assets.icons.google.path),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFFA8B0AF),
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        width: 48,
                        height: 48,
                        child: SvgPicture.asset(Assets.icons.apple.path),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Divider(
                          color: Color(0xFFCDD1D0).withAlpha(51),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        child: const Text(
                          "OR",
                          style: TextStyle(
                            color: Color(0xFFD6E4E0),
                            fontSize: 16,
                            fontFamily: FontFamily.circular,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Color(0xFFCDD1D0).withAlpha(51),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Sign up with email",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: FontFamily.caros,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 46),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Existing account? ",
                        style: TextStyle(
                          color: Color(0xFFB9C1BE),
                          fontSize: 16,
                          fontFamily: FontFamily.circular,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        "Log in",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: FontFamily.circular,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
