import 'package:chatapp/core/providers/firebase_firestore_provider.dart';
import 'package:chatapp/features/auth/data/dto/user_dto.dart';
import 'package:chatapp/features/users/domain/user_repository_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider<UserRepositoryInterface>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return UserRepository(firestore);
});

class UserRepository implements UserRepositoryInterface {
  final FirebaseFirestore _firestore;

  UserRepository(this._firestore);

  @override
  Stream<UserDTO?> getUserDetails(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().map((doc) {
      if (!doc.exists) return null;

      return UserDTO.fromJson(doc.data()!);
    });
  }
}
