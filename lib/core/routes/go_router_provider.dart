import 'package:chatapp/core/providers/firebase_auth_providers.dart';
import 'package:chatapp/core/routes/route_names.dart';
import 'package:chatapp/features/auth/presentation/login_screen.dart';
import 'package:chatapp/features/auth/presentation/signup_screen.dart';
import 'package:chatapp/features/auth/presentation/onboarding_screen.dart';
import 'package:chatapp/features/chat/presentation/chats_list_screen.dart';
import 'package:chatapp/features/home/presentation/home_screen.dart';
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
        path: '/settings',
        name: settingsRoute,
        builder: (context, state) => const ChatsListScreen(),
      ),
      GoRoute(
        path: '/chat/:chatId',
        name: chatRoute,
        builder: (context, state) =>
            ChatScreen(chatId: state.pathParameters['chatId']!),
      ),
    ],
  );
});
