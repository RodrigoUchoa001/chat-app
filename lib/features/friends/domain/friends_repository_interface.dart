abstract interface class FriendsRepositoryInterface {
  Future<void> sendFriendRequest(String friendId);
  Future<void> removeFriend(String friendId);
  Future<void> acceptFriendRequest(String friendId);
  Future<void> rejectFriendRequest(String friendId);
  Stream<List<String>?> getFriends();
  Stream<List<String>?> getFriendsRequests();
}
