import 'package:chatapp/core/localization/app_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseErrorHandler {
  static String handleAuthError(
      FirebaseAuthException e, AppLocalization? localization) {
    switch (e.code) {
      case 'email-already-in-use':
        return localization?.translate('email-already-in-use') ?? '';
      case 'invalid-email':
        return localization?.translate('invalid-email') ?? '';
      case 'weak-password':
        return localization?.translate('weak-password') ?? '';
      case 'wrong-password':
        return localization?.translate('wrong-password') ?? '';
      case 'invalid-credential':
        return localization?.translate('invalid-credential') ?? '';
      case 'user-not-found':
        return localization?.translate('user-not-found') ?? '';
      case 'operation-not-allowed':
        return localization?.translate('operation-not-allowed') ?? '';
      case 'network-request-failed':
        return localization?.translate('network-request-failed') ?? '';
      default:
        return '${localization?.translate('unknown-error') ?? ''} ${e.message}';
    }
  }

  static String handleFirestoreError(
      FirebaseException e, AppLocalization? localization) {
    return '${localization?.translate('firebase-error') ?? ''} ${e.message}';
  }

  static String handleGenericError(dynamic e, AppLocalization? localization) {
    return '${localization?.translate('unexpected-error') ?? ''} $e';
  }
}
