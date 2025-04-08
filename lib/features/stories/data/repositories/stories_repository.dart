import 'package:chatapp/core/providers/firebase_auth_providers.dart';
import 'package:chatapp/core/providers/firebase_firestore_provider.dart';
import 'package:chatapp/features/auth/data/dto/user_dto.dart';
import 'package:chatapp/features/friends/data/repositories/friends_repository.dart';
import 'package:chatapp/features/friends/domain/friends_repository_interface.dart';
import 'package:chatapp/features/stories/data/dto/story_dto.dart';
import 'package:chatapp/features/stories/domain/repositories/stories_repository_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storiesRepositoryProvider = Provider<StoriesRepositoryInterface>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final currentUser = ref.watch(currentUserProvider).asData?.value;
  final friendsRepo = ref.watch(friendsRepositoryProvider);

  return StoriesRepository(firestore, currentUser!.uid, friendsRepo);
});

class StoriesRepository implements StoriesRepositoryInterface {
  final FirebaseFirestore _firestore;
  final String _userId;
  final FriendsRepositoryInterface friendsRepo;

  StoriesRepository(this._firestore, this._userId, this.friendsRepo);

  @override
  Future<void> deleteAllStories() {
    final collection = _firestore.collection('stories');

    return collection.get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc.data()['userId'] == _userId) {
          doc.reference.delete();
        }
      }
    });
  }

  @override
  Future<void> deleteStory(String storyId) {
    final collection = _firestore.collection('stories');

    return collection.doc(storyId).get().then((doc) {
      // check if the story belongs to the user
      if (doc.exists && doc.data()?['userId'] == _userId) {
        return collection.doc(storyId).delete();
      }
    });
  }

  @override
  Stream<StoryDTO?> getStory(String storyId) {
    final collection = _firestore.collection('stories');

    return collection.doc(storyId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data()!;
        return StoryDTO.fromJson(data)..id = snapshot.id;
      }
      return null;
    });
  }

  @override
  Future<void> sendStory(StoryDTO story) {
    final collection = _firestore.collection('stories');

    return collection.doc(story.id).set(story.toJson());
  }

  @override
  Stream<List<UserDTO?>> getFriendsWhoHaveStories() {
    return friendsRepo.getFriends().asyncExpand((friendIds) {
      if (friendIds == null || friendIds.isEmpty) {
        return Stream.value([]);
      }

      final now = DateTime.now().toIso8601String();

      return _firestore
          .collection('stories')
          .where('userId', whereIn: friendIds)
          .where('expiresAt', isGreaterThan: now)
          .snapshots()
          .map((querySnapshot) {
        final userIdsWithStories = querySnapshot.docs
            .map((doc) => doc['userId'] as String)
            .toSet()
            .toList();

        return userIdsWithStories;
      }).asyncExpand((userIdsWithStories) {
        if (userIdsWithStories.isEmpty) return Stream.value([]);

        return _firestore
            .collection('users')
            .where(FieldPath.documentId, whereIn: userIdsWithStories)
            .snapshots()
            .map((querySnapshot) {
          return querySnapshot.docs.map((doc) {
            final data = doc.data();
            return UserDTO.fromJson(data)..uid = doc.id;
          }).toList();
        });
      });
    });
  }

  @override
  Stream<List<StoryDTO?>> getStoriesByUserId(String userId) {
    final now = DateTime.now().toIso8601String();

    return _firestore
        .collection('stories')
        .where('userId', isEqualTo: userId)
        .where('expiresAt', isGreaterThan: now)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return StoryDTO.fromJson(data)..id = doc.id;
      }).toList();
    });
  }
}
