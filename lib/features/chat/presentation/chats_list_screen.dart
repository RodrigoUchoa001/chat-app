import 'package:chatapp/core/widgets/app_bar_widget.dart';
import 'package:chatapp/core/widgets/home_content_background_widget.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_list.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_status_row.dart';
import 'package:chatapp/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class ChatsListScreen extends ConsumerStatefulWidget {
  const ChatsListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatsListScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
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
                  AppBarWidget(
                    leftButton: IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        Assets.icons.search.path,
                        fit: BoxFit.scaleDown,
                        height: 18.33,
                        width: 18.33,
                      ),
                    ),
                    title: 'Home',
                    rightButton: CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  ChatStatusRow(),
                ],
              ),
            ),
            HomeContentBackground(
              height: screenHeight - 313.33,
              child: ChatList(),
            ),
          ],
        ),
      ),
    );
  }
}
