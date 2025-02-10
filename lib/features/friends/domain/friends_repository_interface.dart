abstract interface class FriendsRepositoryInterface {
  Future<void> sendFriendRequest(String friendId);
  Future<void> removeFriend(String friendId);
  Stream<List<String>?> getFriends();
  Stream<List<String>?> getFriendsRequests();
}
