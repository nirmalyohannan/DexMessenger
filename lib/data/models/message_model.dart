class MessageModel {
  String type;
  String message;
  String fromUID;
  String toUID;
  String createdTime;

  MessageModel({
    required this.type,
    required this.message,
    required this.fromUID,
    required this.toUID,
    required this.createdTime,
  });
}
