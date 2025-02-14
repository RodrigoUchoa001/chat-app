import 'package:chatapp/gen/assets.gen.dart';
import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class ChatAppBar extends ConsumerWidget {
  const ChatAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
            child: SvgPicture.asset(
              Assets.icons.search.path,
              fit: BoxFit.scaleDown,
              height: 18.33,
              width: 18.33,
            ),
          ),
          Text(
            'Home',
            style: TextStyle(
              color: Colors.white,
              fontFamily: FontFamily.caros,
              fontSize: 20,
            ),
          ),
          CircleAvatar(
            backgroundImage: NetworkImage(
              scale: 44,
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
            ),
          ),
        ],
      ),
    );
  }
}
