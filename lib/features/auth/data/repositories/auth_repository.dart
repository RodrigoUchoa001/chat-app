import 'package:chatapp/core/providers/firebase_auth_providers.dart';
import 'package:chatapp/core/providers/firebase_firestore_provider.dart';
import 'package:chatapp/features/auth/data/dto/user_dto.dart';
import 'package:chatapp/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod/riverpod.dart';

final authRepositoryProvider = Provider<AuthRepositoryInterface>((ref) {
  final auth = ref.watch(authProvider);
  final firestore = ref.watch(firestoreProvider);
  return AuthRepository(auth, firestore);
});

class AuthRepository implements AuthRepositoryInterface {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthRepository(this._auth, this._firestore);

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
            createdAt: FieldValue.serverTimestamp().toString(),
            isOnline: true,
            lastSeen: null,
            friends: [],
            friendRequests: [],
            fcmToken: '',
          ).toJson(),
        );
      } else {
        await userRef.update({'isOnline': true});
      }

      return true;
    } catch (e) {
      print('Erro no login com Google: $e');
      return false;
    }
  }

  @override
  Future<bool> loginWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) return false;

      final userRef = _firestore.collection('users').doc(user.uid);
      await userRef.update({'isOnline': true});

      return true;
    } catch (e) {
      print('Erro no login com email e senha: $e');
      return false;
    }
  }

  @override
  Future<bool> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) return false;

      final userRef = _firestore.collection('users').doc(user.uid);

      await userRef.set(
        UserDTO(
          name: user.displayName ?? 'No Name',
          email: user.email,
          photoURL: user.photoURL ?? '',
          createdAt: FieldValue.serverTimestamp().toString(),
          isOnline: true,
          lastSeen: null,
          friends: [],
          friendRequests: [],
          fcmToken: '',
        ).toJson(),
      );

      return true;
    } catch (e) {
      print('Erro no registro com email e senha: $e');
      return false;
    }
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
