import 'package:chatapp/core/errors/firebase_error_handler.dart';
import 'package:chatapp/core/localization/app_localization.dart';
import 'package:chatapp/core/localization/locale_provider.dart';
import 'package:chatapp/core/providers/firebase_auth_providers.dart';
import 'package:chatapp/core/providers/firebase_firestore_provider.dart';
import 'package:chatapp/features/auth/data/dto/user_dto.dart';
import 'package:chatapp/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authRepositoryProvider = Provider<AuthRepositoryInterface>((ref) {
  final auth = ref.watch(authProvider);
  final firestore = ref.watch(firestoreProvider);

  final locale = ref.watch(localeProvider);
  final localization = ref.watch(localizationProvider(locale)).value;

  return AuthRepository(auth, firestore, localization);
});

class AuthRepository implements AuthRepositoryInterface {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final AppLocalization? _localization;

  AuthRepository(this._auth, this._firestore, this._localization);

  @override
  Future<bool> loginWithGoogle() async {
    try {
      final googleAccount = await _googleSignIn.signIn();
      if (googleAccount == null) return false;

      final googleAuth = await googleAccount.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) return false;

      final userRef = _firestore.collection('users').doc(user.uid);

      final userSnapshot = await userRef.get();
      if (!userSnapshot.exists) {
        await userRef.set(
          UserDTO(
            name: user.displayName ?? 'No Name',
            email: user.email,
            photoURL: user.photoURL ?? '',
            createdAt: DateTime.now().toString(),
            isOnline: true,
            lastSeen: null,
            friends: [],
            friendRequests: [],
            fcmToken: '',
            statusMessage: '',
          ).toJson(),
        );
      } else {
        await userRef.update({'isOnline': true});
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Erro no login com Google: $e');
      }
      return false;
    }
  }

  @override
  Future<String?> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        return _localization?.translate('erro-while-logging-in');
      }

      final userRef = _firestore.collection('users').doc(user.uid);
      await userRef.update({'isOnline': true});

      return null;
    } on FirebaseAuthException catch (e) {
      return FirebaseErrorHandler.handleAuthError(e, _localization);
    } on FirebaseException catch (e) {
      return FirebaseErrorHandler.handleFirestoreError(e, _localization);
    } catch (e) {
      return FirebaseErrorHandler.handleGenericError(e, _localization);
    }
  }

  @override
  Future<String?> registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        return _localization?.translate('erro-while-registering') ?? '';
      }

      final userRef = _firestore.collection('users').doc(user.uid);

      final userData = UserDTO(
        name: name,
        email: user.email,
        photoURL: user.photoURL ?? '',
        createdAt: DateTime.now().toString(),
        isOnline: true,
        lastSeen: null,
        friends: [],
        friendRequests: [],
        fcmToken: '',
        statusMessage: '',
      ).toJson();

      await userRef.set(userData);

      return null;
    } on FirebaseAuthException catch (e) {
      return FirebaseErrorHandler.handleAuthError(e, _localization);
    } on FirebaseException catch (e) {
      return FirebaseErrorHandler.handleFirestoreError(e, _localization);
    } catch (e) {
      return FirebaseErrorHandler.handleGenericError(e, _localization);
    }
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
