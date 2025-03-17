import 'package:chatapp/core/localization/app_localization.dart';
import 'package:chatapp/core/localization/locale_provider.dart';
import 'package:chatapp/core/widgets/app_bar_widget.dart';
import 'package:chatapp/core/widgets/home_content_background_widget.dart';
import 'package:chatapp/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

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

    final locale = ref.watch(localeProvider);
    final localization = ref.watch(localizationProvider(locale)).value;

    // TODO: create user details screen
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
                        Assets.icons.search.path,
                        fit: BoxFit.scaleDown,
                        height: 18.33,
                        width: 18.33,
                      ),
                    ),
                    title: "fulano de tal",
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
            HomeContentBackground(
              height: screenHeight - 190, //CHUTEI ESSE NUMERO
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
