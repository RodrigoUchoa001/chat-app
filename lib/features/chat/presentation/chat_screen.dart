import 'package:chatapp/features/chat/presentation/widgets/chat_app_bar.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_list.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_status_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        // NEXT TODO: Implement chat screen now using firebase
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF24786D),
              ),
              child: Column(
                children: [
                  SizedBox(height: 17),
                  ChatAppBar(),
                  SizedBox(height: 40),
                  ChatStatusRow(),
                ],
              ),
            ),
            Container(
              height: screenHeight -
                  313.33, // 313.33 is the height of all the widgets above
              decoration: BoxDecoration(
                color: Color(0xFF121414),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: ChatList(),
            ),
          ],
        ),
      ),
    );
  }
}
