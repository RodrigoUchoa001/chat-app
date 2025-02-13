import 'package:chatapp/core/providers/bottom_nav_index_provider.dart';
import 'package:chatapp/features/chat/presentation/chat_screen.dart';
import 'package:chatapp/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    final List<Widget> pages = [
      const ChatScreen(),
      const ChatScreen(),
      const ChatScreen(),
    ];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) =>
            ref.read(bottomNavIndexProvider.notifier).state = index,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(Assets.icons.message.path),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(Assets.icons.user.path),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(Assets.icons.settings.path),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
