import 'package:chatapp/features/auth/data/dto/user_dto.dart';
import 'package:chatapp/features/stories/data/dto/story_dto.dart';

abstract interface class StoriesRepositoryInterface {
  Stream<List<UserDTO?>> getFriendsWhoHaveStories();
  Stream<List<StoryDTO?>> getStoriesByUserId(String userId);
  Stream<StoryDTO?> getStory(String storyId);
  Future<void> likeStory(String storyId);
  Future<void> unlikeStory(String storyId);
  Stream<List<String>> getStoryLikes(String storyId);
  Stream<bool> isStoryLikedByMe(String storyId);
  Future<void> sendStory(StoryDTO story);
  Future<void> deleteStory(String storyId);
  Future<void> deleteAllStories();
}
