import 'package:firebase_auth/firebase_auth.dart';

class FirebaseErrorHandler {
  static String handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email already in use.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'wrong-password':
        return 'The password is invalid for the given email.';
      case 'invalid-credential':
        return 'The supplied auth credential is malformed or has expired.';
      case 'user-not-found':
        return 'No user found with the given email.';
      case 'operation-not-allowed':
        return 'The operation is not allowed.';
      case 'network-request-failed':
        return 'A network error has occurred.';
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
