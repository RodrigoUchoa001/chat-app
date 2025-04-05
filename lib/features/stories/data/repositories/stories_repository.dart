import 'package:chatapp/features/stories/data/dto/story_dto.dart';
import 'package:chatapp/features/stories/domain/repositories/stories_repository_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoriesRepository implements StoriesRepositoryInterface {
  final FirebaseFirestore _firestore;
  final String _userId;

  StoriesRepository(this._firestore, this._userId);

  @override
  Future<void> deleteAllStories() {
    // TODO: implement deleteAllStories
    throw UnimplementedError();
  }

  @override
  Future<void> deleteStory(String storyId) {
    // TODO: implement deleteStory
    throw UnimplementedError();
  }

  @override
  Stream<List<StoryDTO?>> getStories() {
    // TODO: implement getStories
    throw UnimplementedError();
  }

  @override
  Stream<StoryDTO?> getStory(String storyId) {
    // TODO: implement getStory
    throw UnimplementedError();
  }

  @override
  Future<void> sendStory(StoryDTO story) {
    // TODO: implement sendStory
    throw UnimplementedError();
  }

  @override
  Future<void> updateStory(String storyId, StoryDTO story) {
    // TODO: implement updateStory
    throw UnimplementedError();
  }
}
