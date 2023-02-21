
class SearchResultModel {
  String dpUrl;
  String name;
  String uid;
  SearchResultModel(
      {required this.dpUrl, required this.name, required this.uid});

  factory SearchResultModel.fromJson(Map<String, dynamic> map) {
    return SearchResultModel(
        dpUrl: map['image'], name: map['name'], uid: map['uid']);
  }
}
