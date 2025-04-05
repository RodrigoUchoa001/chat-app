import 'package:chatapp/features/stories/data/dto/story_dto.dart';

abstract interface class StoriesRepositoryInterface {
  Stream<List<StoryDTO>> getStories();
  Stream<StoryDTO?> getStory(String storyId);
  Future<void> sendStory();
  Future<void> deleteStory();
  Future<void> updateStory();
  Future<void> deleteAllStories();
}
