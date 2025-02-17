import 'package:chatapp/core/providers/bottom_nav_index_provider.dart';
import 'package:chatapp/features/chat/presentation/chats_list_screen.dart';
import 'package:chatapp/gen/assets.gen.dart';
import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    final List<Widget> pages = [
      const ChatsListScreen(),
      const ChatsListScreen(),
      const ChatsListScreen(),
    ];

    return SafeArea(
      child: Scaffold(
        body: pages[currentIndex],
        bottomNavigationBar: SizedBox(
          height: 90,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF242E2E),
                width: 1,
              ),
            ),
            child: BottomNavigationBar(
              backgroundColor: const Color(0xFF121414),
              selectedItemColor: Colors.white,
              unselectedItemColor: const Color(0xFF797C7B),
              selectedLabelStyle: const TextStyle(
                fontFamily: FontFamily.caros,
                fontSize: 16,
                color: Colors.white,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: FontFamily.caros,
                fontSize: 16,
                color: Color(0xFF797C7B),
              ),
              showSelectedLabels: true,
              currentIndex: currentIndex,
              onTap: (index) =>
                  ref.read(bottomNavIndexProvider.notifier).state = index,
              items: [
                BottomNavigationBarItem(
                  icon: _buildSvgIcon(
                      Assets.icons.message.path, currentIndex == 0),
                  label: 'Chats',
                ),
                BottomNavigationBarItem(
                  icon:
                      _buildSvgIcon(Assets.icons.user.path, currentIndex == 1),
                  label: 'Friends',
                ),
                BottomNavigationBarItem(
                  icon: _buildSvgIcon(
                      Assets.icons.settings.path, currentIndex == 2),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSvgIcon(String assetPath, bool isSelected) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        isSelected ? Colors.white : const Color(0xFF797C7B),
        BlendMode.srcIn,
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: SvgPicture.asset(assetPath, width: 26, height: 26),
      ),
    );
  }
}
