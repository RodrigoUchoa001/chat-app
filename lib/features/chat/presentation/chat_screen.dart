import 'package:chatapp/features/chat/presentation/widgets/chat_app_bar.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_status_row.dart';
import 'package:chatapp/gen/fonts.gen.dart';
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
        // NEXT TODO: Implement chat screen
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
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 26),
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                    radius: 26,
                                    backgroundImage: NetworkImage(
                                      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Color(0xFF0FE16D),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Alex Linderson',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: FontFamily.caros,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'How are you today?',
                                    style: TextStyle(
                                      color: Color(0xFF797C7B),
                                      fontSize: 12,
                                      fontFamily: FontFamily.circular,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                '2 min ago',
                                style: TextStyle(
                                  color: Color(0xFF797C7B),
                                  fontSize: 12,
                                  fontFamily: FontFamily.circular,
                                ),
                              ),
                              const SizedBox(height: 7),
                              Container(
                                width: 21.81,
                                height: 21.81,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Color(0xFFF04A4C),
                                ),
                                child: Center(
                                  child: const Text(
                                    '3',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontFamily: FontFamily.circular,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
