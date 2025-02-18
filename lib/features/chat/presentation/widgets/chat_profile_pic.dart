import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatProfilePic extends ConsumerWidget {
  final String groupPhotoURL;
  final bool isOnline;
  const ChatProfilePic(
      {required this.groupPhotoURL, required this.isOnline, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 26,
          backgroundImage: NetworkImage(
            groupPhotoURL,
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
