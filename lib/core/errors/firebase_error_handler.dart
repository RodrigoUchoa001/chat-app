import 'package:firebase_auth/firebase_auth.dart';

class FirebaseErrorHandler {
  static String handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email Already in use.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password provided is too weak.';
      default:
        return 'Unknown error: ${e.message}';
    }
  }

  static String handleFirestoreError(FirebaseException e) {
    return 'Firestore database error: ${e.message}';
  }

  static String handleGenericError(dynamic e) {
    return 'Unexpected error: $e';
  }
}
