import 'dart:convert';

import 'package:flutter/foundation.dart';

class StoryModel {
  List<SingleStoryModel> storiesList;
  String uid;
  StoryModel({
    required this.storiesList,
    required this.uid,
  });

  StoryModel copyWith({
    List<SingleStoryModel>? storiesList,
    String? uid,
  }) {
    return StoryModel(
      storiesList: storiesList ?? this.storiesList,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'storiesList': storiesList.map((x) => x.toMap()).toList(),
      'uid': uid,
    };
  }

  factory StoryModel.fromMap(Map<String, dynamic> map) {
    return StoryModel(
      storiesList: List<SingleStoryModel>.from(
          map['storiesList']?.map((x) => SingleStoryModel.fromMap(x))),
      uid: map['uid'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory StoryModel.fromJson(String source) =>
      StoryModel.fromMap(json.decode(source));

  @override
  String toString() => 'StoryModel(storiesList: $storiesList, uid: $uid)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StoryModel &&
        listEquals(other.storiesList, storiesList) &&
        other.uid == uid;
  }

  @override
  int get hashCode => storiesList.hashCode ^ uid.hashCode;
}

class SingleStoryModel {
  String url;
  String createdTime;
  SingleStoryModel({
    required this.url,
    required this.createdTime,
  });

  SingleStoryModel copyWith({
    String? url,
    String? createdTime,
  }) {
    return SingleStoryModel(
      url: url ?? this.url,
      createdTime: createdTime ?? this.createdTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'createdTime': createdTime,
    };
  }

  factory SingleStoryModel.fromMap(Map<String, dynamic> map) {
    return SingleStoryModel(
      url: map['url'] ?? '',
      createdTime: map['createdTime'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SingleStoryModel.fromJson(String source) =>
      SingleStoryModel.fromMap(json.decode(source));

  @override
  String toString() => 'SingleStoryModel(url: $url, createdTime: $createdTime)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SingleStoryModel &&
        other.url == url &&
        other.createdTime == createdTime;
  }

  @override
  int get hashCode => url.hashCode ^ createdTime.hashCode;
}
