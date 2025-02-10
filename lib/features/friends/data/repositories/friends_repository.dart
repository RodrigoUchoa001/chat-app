import 'package:chatapp/core/providers/firebase_auth_providers.dart';
import 'package:chatapp/core/providers/firebase_firestore_provider.dart';
import 'package:chatapp/features/friends/domain/friends_repository_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final friendsRepositoryProvider = Provider<FriendsRepositoryInterface>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final currentUser = ref.watch(currentUserProvider).asData?.value;

  return FriendsRepository(firestore, currentUser!.uid);
});

class FriendsRepository implements FriendsRepositoryInterface {
  final FirebaseFirestore _firestore;
  final String _userId;

  FriendsRepository(this._firestore, this._userId);

  @override
  Stream<List<String>?> getFriends() {
    return _firestore.collection('users').doc(_userId).snapshots().map((doc) {
      return List<String>.from(doc.data()?['friends'] ?? []);
    });
  }

  @override
  Stream<List<String>?> getFriendsRequests() {
    return _firestore.collection('users').doc(_userId).snapshots().map((doc) {
      return List<String>.from(doc.data()?['friendRequests'] ?? []);
    });
  }

  @override
  Future<void> removeFriend(String friendId) {
    final userRef = _firestore.collection('users').doc(_userId);

    return userRef.update({
      'friends': FieldValue.arrayRemove([friendId]),
    });
  }

  @override
  Future<void> sendFriendRequest(String friendId) {
    final userRef = _firestore.collection('users').doc(friendId);

    return userRef.update({
      'friendRequests': FieldValue.arrayUnion([_userId]),
    });
  }

  @override
  Future<void> acceptFriendRequest(String friendId) {
    final userRef = _firestore.collection('users').doc(_userId);

    return userRef.update({
      'friends': FieldValue.arrayUnion([friendId]),
      'friendRequests': FieldValue.arrayRemove([friendId]),
    });
  }

  @override
  Future<void> rejectFriendRequest(String friendId) {
    final userRef = _firestore.collection('users').doc(_userId);

    return userRef.update({
      'friendRequests': FieldValue.arrayRemove([friendId]),
    });
  }
}
