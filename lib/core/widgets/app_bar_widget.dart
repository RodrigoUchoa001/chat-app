import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppBarWidget extends ConsumerWidget {
  final Widget? leftButton;
  final String title;
  final Widget? rightButton;
  const AppBarWidget(
      {this.leftButton, required this.title, this.rightButton, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        height: 44,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (leftButton != null)
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFF4B9289),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: leftButton,
              )
            else
              const SizedBox(),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontFamily: FontFamily.caros,
                fontSize: 20,
              ),
            ),
            if (rightButton != null)
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFF4B9289),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: rightButton,
              )
            else
              const SizedBox(),
          ],
        ),
      ),
    );
  }
}
