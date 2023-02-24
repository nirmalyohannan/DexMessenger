class RecipentInfoModel {
  String recipentName;
  String recipentDpUrl;
  String recipentUID;

  RecipentInfoModel(
      {required this.recipentDpUrl,
      required this.recipentName,
      required this.recipentUID});

  factory RecipentInfoModel.fromJson(Map<String, dynamic> json) {
    return RecipentInfoModel(
        recipentDpUrl: json['image'],
        recipentName: json['name'],
        recipentUID: json['uid']);
  }
}
