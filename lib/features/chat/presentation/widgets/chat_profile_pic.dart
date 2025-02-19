import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatProfilePic extends ConsumerWidget {
  final String chatPhotoURL;
  final bool isOnline;
  const ChatProfilePic(
      {required this.chatPhotoURL, required this.isOnline, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 26,
          backgroundImage: NetworkImage(
            chatPhotoURL,
          ),
        ),
        isOnline
            ? Padding(
                padding: const EdgeInsets.all(4),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xFF0FE16D),
                  ),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
