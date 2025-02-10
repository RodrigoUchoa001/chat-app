class UserDTO {
  String? username;
  String? email;
  String? photoURL;
  String? name;
  List<String>? friends;
  List<String>? friendRequests;
  String? createdAt;
  String? lastSeen;
  bool? isOnline;
  String? fcmToken;

  UserDTO(
      {this.username,
      this.email,
      this.photoURL,
      this.name,
      this.friends,
      this.friendRequests,
      this.createdAt,
      this.lastSeen,
      this.isOnline,
      this.fcmToken});

  UserDTO.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    photoURL = json['photoURL'];
    name = json['name'];
    friends = json['friends'].cast<String>();
    friendRequests = json['friendRequests'].cast<String>();
    createdAt = json['createdAt'];
    lastSeen = json['lastSeen'];
    isOnline = json['isOnline'];
    fcmToken = json['fcmToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['email'] = email;
    data['photoURL'] = photoURL;
    data['name'] = name;
    data['friends'] = friends;
    data['friendRequests'] = friendRequests;
    data['createdAt'] = createdAt;
    data['lastSeen'] = lastSeen;
    data['isOnline'] = isOnline;
    data['fcmToken'] = fcmToken;
    return data;
  }
}
