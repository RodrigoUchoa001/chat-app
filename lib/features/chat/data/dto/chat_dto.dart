class ChatDTO {
  String? type;
  String? groupName;
  String? groupPhotoURL;
  List<String>? admins;
  List<String>? participants;
  MessageDTO? lastMessage;
  String? createdAt;

  ChatDTO(
      {this.type,
      this.groupName,
      this.groupPhotoURL,
      this.admins,
      this.participants,
      this.lastMessage,
      this.createdAt});

  ChatDTO.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    groupName = json['groupName'];
    groupPhotoURL = json['groupPhotoURL'];
    admins = json['admins'].cast<String>();
    participants = json['participants'].cast<String>();
    lastMessage = json['lastMessage'] != null
        ? MessageDTO.fromJson(json['lastMessage'])
        : null;
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['groupName'] = groupName;
    data['groupPhotoURL'] = groupPhotoURL;
    data['admins'] = admins;
    data['participants'] = participants;
    if (lastMessage != null) {
      data['lastMessage'] = lastMessage!.toJson();
    }
    data['createdAt'] = createdAt;
    return data;
  }
}

class MessageDTO {
  String? senderId;
  String? text;
  String? timestamp;

  MessageDTO({this.senderId, this.text, this.timestamp});

  MessageDTO.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    text = json['text'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['senderId'] = senderId;
    data['text'] = text;
    data['timestamp'] = timestamp;
    return data;
  }
}
