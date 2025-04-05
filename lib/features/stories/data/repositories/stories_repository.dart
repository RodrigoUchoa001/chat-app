import 'package:chatapp/features/stories/data/dto/story_dto.dart';
import 'package:chatapp/features/stories/domain/repositories/stories_repository_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoriesRepository implements StoriesRepositoryInterface {
  final FirebaseFirestore _firestore;
  final String _userId;

  StoriesRepository(this._firestore, this._userId);

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
  Stream<List<StoryDTO?>> getStories() {
    final collection = _firestore.collection('stories');

    return collection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return StoryDTO.fromJson(data)..id = doc.id;
      }).toList();
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
}
