class MessageModel {
  String type;
  String content;
  String fromUID;
  String toUID;
  String createdTime;

  MessageModel({
    required this.type,
    required this.content,
    required this.fromUID,
    required this.toUID,
    required this.createdTime,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
        type: json['type'],
        content: json['content'],
        fromUID: json['fromUID'],
        toUID: json['toUID'],
        createdTime: json['createdTime']);
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'content': content,
      'fromUID': fromUID,
      'toUID': toUID,
      'createdTime': createdTime
    };
  }
}
