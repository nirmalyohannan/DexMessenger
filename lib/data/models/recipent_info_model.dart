class RecipentInfoModel {
  String recipentName;
  String recipentDpUrl;
  String recipentUID;
  String? recipentFcmToken;

  RecipentInfoModel(
      {required this.recipentDpUrl,
      required this.recipentName,
      required this.recipentUID,
      this.recipentFcmToken});

  factory RecipentInfoModel.fromJson(Map<String, dynamic> json) {
    return RecipentInfoModel(
        recipentDpUrl: json['image'],
        recipentName: json['name'],
        recipentUID: json['uid'],
        recipentFcmToken: json['fcmToken']);
  }
}
