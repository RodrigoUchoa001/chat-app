import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';

final authProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final currentUserProvider = StreamProvider<User?>((ref) {
  return ref.watch(authProvider).authStateChanges();
});
