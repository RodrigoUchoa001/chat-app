import 'package:chatapp/core/localization/app_localization.dart';
import 'package:chatapp/core/localization/locale_provider.dart';
import 'package:chatapp/core/providers/firebase_auth_providers.dart';
import 'package:chatapp/core/theme/is_dark_mode.dart';
import 'package:chatapp/core/theme/theme_provider.dart';
import 'package:chatapp/core/widgets/app_bar_widget.dart';
import 'package:chatapp/core/widgets/home_content_background_widget.dart';
import 'package:chatapp/features/chat/data/repositories/chat_repository.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_profile_pic.dart';
import 'package:chatapp/features/users/data/repositories/user_repository.dart';
import 'package:chatapp/features/users/presentation/widgets/user_details.dart';
import 'package:chatapp/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class UserDetailsScreen extends ConsumerStatefulWidget {
  final String userId;
  const UserDetailsScreen({required this.userId, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserDetailsScreenState();
}

class _UserDetailsScreenState extends ConsumerState<UserDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final userRepo = ref.watch(userRepositoryProvider);
    final chatRepo = ref.watch(chatRepositoryProvider);

    final currentUser = ref.watch(currentUserProvider).asData?.value;

    final themeMode = ref.watch(themeProvider);

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
                        context.pop();
                      },
                      icon: SvgPicture.asset(
                        Assets.icons.backButton.path,
                        fit: BoxFit.scaleDown,
                        height: 18.33,
                        width: 18.33,
                      ),
                    ),
                    title: "",
                  ),
                  Column(
                    children: [
                      StreamBuilder(
                        stream: userRepo.getUserDetails(widget.userId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          final user = snapshot.data!;

                          final chatPhoto = user.photoURL;

                          final hasValidPhoto =
                              chatPhoto != null && chatPhoto.isNotEmpty;

                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (hasValidPhoto) {
                                    context
                                        .push('/view-profile-pic/${user.uid}');
                                  } else if (!hasValidPhoto &&
                                      currentUser!.uid == widget.userId) {
                                    context
                                        .push('/view-profile-pic/${user.uid}');
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: 'This user has no profile picture',
                                    );
                                  }
                                },
                                child: Hero(
                                  tag: 'profilePic',
                                  child: ChatProfilePic(
                                    avatarRadius: 41,
                                    chatPhotoURL:
                                        hasValidPhoto ? chatPhoto : null,
                                    isOnline: user.isOnline!,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                user.name ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                user.isOnline!
                                    ? 'Online'
                                    : lastSeenDateOrTime(user.lastSeen!, ref),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      fontSize: 12,
                                      color: Color(0xFFA5E7DE),
                                    ),
                              ),
                              const SizedBox(height: 20),
                              currentUser!.uid != widget.userId
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        _profileIconButton(
                                          Assets.icons.message.path,
                                          () async {
                                            context.push(
                                                '/chat/${await chatRepo.getPrivateChatIdByFriendId(widget.userId)}');
                                          },
                                          themeMode,
                                        ),
                                        const SizedBox(width: 33),
                                        _profileIconButton(
                                          Assets.icons.video.path,
                                          () {},
                                          themeMode,
                                        ),
                                        const SizedBox(width: 33),
                                        _profileIconButton(
                                          Assets.icons.call.path,
                                          () {},
                                          themeMode,
                                        ),
                                        const SizedBox(width: 33),
                                        _profileIconButton(
                                          Assets.icons.more.path,
                                          () {},
                                          themeMode,
                                        ),
                                      ],
                                    )
                                  : SizedBox(height: 19.5),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            HomeContentBackground(
              height: screenHeight -
                  (currentUser!.uid != widget.userId ? 313.33 : 250),
              child: StreamBuilder(
                stream: userRepo.getUserDetails(widget.userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  final user = snapshot.data!;
                  return UserDetails(user: user);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconButton _profileIconButton(
    String iconPath,
    Function() onPressed,
    ThemeMode themeMode,
  ) {
    return IconButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          isDarkMode(ref, context)
              ? Color.fromARGB(100, 5, 29, 19)
              : Color.fromARGB(20, 0, 14, 12),
        ),
      ),
      icon: SvgPicture.asset(
        iconPath,
        colorFilter: ColorFilter.mode(
          Colors.white,
          BlendMode.srcIn,
        ),
        fit: BoxFit.scaleDown,
        width: 19.5,
      ),
    );
  }

  String lastSeenDateOrTime(String timestamp, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final localization = ref.watch(localizationProvider(locale)).value;
    final lastSeenDate = DateTime.parse(timestamp);

    if (lastSeenDate.day == DateTime.now().day) {
      return "${localization?.translate("last-seen-at") ?? ""} ${DateFormat('HH:mm').format(
        DateTime.parse(timestamp),
      )}";
    } else {
      return "${localization?.translate("last-seen-in") ?? ""} ${DateFormat('dd/MM/yyyy').format(
        DateTime.parse(timestamp),
      )}";
    }
  }
}
