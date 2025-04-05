import 'package:chatapp/features/stories/data/dto/story_dto.dart';

abstract interface class StoriesRepositoryInterface {
  Stream<List<StoryDTO?>> getStories();
  Stream<StoryDTO?> getStory(String storyId);
  Future<void> sendStory(StoryDTO story);
  Future<void> deleteStory(String storyId);
  Future<void> updateStory(String storyId, StoryDTO story);
  Future<void> deleteAllStories();
}
