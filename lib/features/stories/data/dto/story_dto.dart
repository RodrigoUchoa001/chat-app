class StoryDTO {
  String? id;
  String? userId;
  String? mediaURL;
  String? mediaType;
  String? caption;
  String? createdAt;
  String? expiresAt;
  List<String>? views;
  List<String>? likes;

  StoryDTO(
      {this.id,
      this.userId,
      this.mediaURL,
      this.mediaType,
      this.caption,
      this.createdAt,
      this.expiresAt,
      this.views,
      this.likes});

  StoryDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    mediaURL = json['mediaURL'];
    mediaType = json['mediaType'];
    caption = json['caption'];
    createdAt = json['createdAt'];
    expiresAt = json['expiresAt'];
    views = json['views'].cast<String>();
    likes = json['likes'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['mediaURL'] = mediaURL;
    data['mediaType'] = mediaType;
    data['caption'] = caption;
    data['createdAt'] = createdAt;
    data['expiresAt'] = expiresAt;
    data['views'] = views;
    data['likes'] = likes;
    return data;
  }

  StoryDTO copyWith({
    String? id,
    String? userId,
    String? mediaURL,
    String? mediaType,
    String? caption,
    String? createdAt,
    String? expiresAt,
    List<String>? views,
    List<String>? likes,
  }) {
    return StoryDTO(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mediaURL: mediaURL ?? this.mediaURL,
      mediaType: mediaType ?? this.mediaType,
      caption: caption ?? this.caption,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      views: views ?? this.views,
      likes: likes ?? this.likes,
    );
  }
}
