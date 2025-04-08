import 'package:chatapp/core/providers/firebase_auth_providers.dart';
import 'package:chatapp/core/routes/route_names.dart';
import 'package:chatapp/features/auth/presentation/login_screen.dart';
import 'package:chatapp/features/auth/presentation/signup_screen.dart';
import 'package:chatapp/features/auth/presentation/onboarding_screen.dart';
import 'package:chatapp/features/chat/presentation/chat_screen.dart';
import 'package:chatapp/features/chat/presentation/chats_list_screen.dart';
import 'package:chatapp/features/chat/presentation/create_group_screen.dart';
import 'package:chatapp/features/chat/presentation/select_friends_to_create_group_screen.dart';
import 'package:chatapp/features/chat/presentation/send_media_confirmation_screen.dart';
import 'package:chatapp/features/stories/presentation/send_story_confirmation_screen.dart';
import 'package:chatapp/features/chat/presentation/view_media_screen.dart';
import 'package:chatapp/features/friends/presentation/add_friend_screen.dart';
import 'package:chatapp/features/home/presentation/home_screen.dart';
import 'package:chatapp/features/search/presentation/search_screen.dart';
import 'package:chatapp/features/settings/presentation/account_settings_screen.dart';
import 'package:chatapp/features/settings/presentation/app_settings_screen.dart';
import 'package:chatapp/features/settings/presentation/chat_settings_screen.dart';
import 'package:chatapp/features/settings/presentation/settings_screen.dart';
import 'package:chatapp/features/users/presentation/user_details_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final user = ref.watch(currentUserProvider).asData?.value;

  return GoRouter(
    initialLocation: user == null ? '/onboarding' : '/home',
    routes: [
      GoRoute(
        path: '/onboarding',
        name: onBoardingRoute,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: loginRoute,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: signupRoute,
        builder: (context, state) => const SignupScreen(),
      ),
      // home
      GoRoute(
        path: '/home',
        name: homeRoute,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/chats-list',
        name: chatsList,
        builder: (context, state) => const ChatsListScreen(),
      ),
      GoRoute(
        path: '/friends',
        name: friendsRoute,
        builder: (context, state) => const ChatsListScreen(),
      ),
      GoRoute(
        path: '/add-friends',
        name: addFriendsRoute,
        builder: (context, state) => const AddFriendScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: settingsRoute,
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'account-settings',
            name: accountSettingsRoute,
            builder: (context, state) => const AccountSettingsScreen(),
          ),
          GoRoute(
            path: 'chat-settings',
            name: chatSettingsRoute,
            builder: (context, state) => const ChatSettingsScreen(),
          ),
          GoRoute(
            path: 'app-settings',
            name: appSettingsRoute,
            builder: (context, state) => const AppSettingsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/chat/:chatId',
        name: chatRoute,
        builder: (context, state) =>
            ChatScreen(chatId: state.pathParameters['chatId']!),
      ),
      GoRoute(
        path: '/search',
        name: searchRoute,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/create-group',
        name: createGroupRoute,
        builder: (context, state) => const CreateGroupScreen(),
      ),
      GoRoute(
        path: '/select-friends-to-create-group',
        name: selectFriendsToCreateGroupRoute,
        builder: (context, state) => const SelectFriendsToCreateGroupScreen(),
      ),
      GoRoute(
        path: '/user-details/:userId',
        name: userDetailsRoute,
        builder: (context, state) =>
            UserDetailsScreen(userId: state.pathParameters['userId']!),
      ),
      GoRoute(
        path: '/send-media-confirmation',
        name: sendMediaConfirmationRoute,
        builder: (context, state) {
          final chatId = state.uri.queryParameters['chatId'];
          final mediaPath = state.uri.queryParameters['mediaPath'];

          return SendMediaConfirmationScreen(
            chatId: chatId!,
            mediaFilePath: mediaPath!,
          );
        },
      ),
      GoRoute(
        path: '/view-media',
        name: viewMediaRoute,
        builder: (context, state) {
          final mediaUrl = state.uri.queryParameters['mediaUrl'];

          return ViewMediaScreen(
            mediaUrl: mediaUrl!,
          );
        },
      ),
      GoRoute(
        path: '/send-story-confirmation',
        name: sendStoryConfirmationRoute,
        builder: (context, state) {
          final mediaPath = state.uri.queryParameters['mediaPath'];

          return SendStoryConfirmationScreen(
            mediaFilePath: mediaPath!,
          );
        },
      ),
    ],
  );
});
