import 'package:chatapp/core/localization/app_localization.dart';
import 'package:chatapp/core/localization/locale_provider.dart';
import 'package:chatapp/core/providers/firebase_auth_providers.dart';
import 'package:chatapp/core/widgets/app_bar_widget.dart';
import 'package:chatapp/core/widgets/home_content_background_widget.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_list.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_profile_pic.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_stories_row.dart';
import 'package:chatapp/features/users/data/repositories/user_repository.dart';
import 'package:chatapp/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class ChatsListScreen extends ConsumerStatefulWidget {
  const ChatsListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatsListScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final currentUser = ref.watch(currentUserProvider).asData?.value;
    final userRepo = ref.watch(userRepositoryProvider);

    final locale = ref.watch(localeProvider);
    final localization = ref.watch(localizationProvider(locale)).value;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
              ),
              child: Column(
                children: [
                  SizedBox(height: 17),
                  AppBarWidget(
                    leftButton: IconButton(
                      onPressed: () {
                        context.push('/search');
                      },
                      icon: SvgPicture.asset(
                        Assets.icons.search.path,
                        fit: BoxFit.scaleDown,
                        height: 18.33,
                        width: 18.33,
                      ),
                    ),
                    title: localization?.translate("home") ?? "",
                    rightButton: GestureDetector(
                      onTap: () =>
                          context.push('/user-details/${currentUser.uid}'),
                      child: StreamBuilder(
                        stream: userRepo.getUserDetails(currentUser!.uid),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          final user = snapshot.data!;
                          return ChatProfilePic(
                            avatarRadius: 22,
                            chatPhotoURL: user.photoURL,
                            isOnline: false,
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  ChatStoriesRow(),
                ],
              ),
            ),
            HomeContentBackground(
              height: screenHeight - 313.33,
              child: ChatList(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF24786D),
          onPressed: () {
            context.push('/create-group');
          },
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
