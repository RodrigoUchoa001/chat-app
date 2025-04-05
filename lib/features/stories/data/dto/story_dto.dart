class StoryDTO {
  String? mediaURL;
  String? mediaType;
  String? caption;
  String? createdAt;
  String? expiresAt;
  List<String>? views;

  StoryDTO(
      {this.mediaURL,
      this.mediaType,
      this.caption,
      this.createdAt,
      this.expiresAt,
      this.views});

  StoryDTO.fromJson(Map<String, dynamic> json) {
    mediaURL = json['mediaURL'];
    mediaType = json['mediaType'];
    caption = json['caption'];
    createdAt = json['createdAt'];
    expiresAt = json['expiresAt'];
    views = json['views'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mediaURL'] = mediaURL;
    data['mediaType'] = mediaType;
    data['caption'] = caption;
    data['createdAt'] = createdAt;
    data['expiresAt'] = expiresAt;
    data['views'] = views;
    return data;
  }
}
