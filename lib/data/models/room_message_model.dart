import 'dart:convert';

import 'package:flutter/foundation.dart';

class RoomMessageModel {
  String type;
  String content;
  String fromUID;
  String toRoomID;
  String createdTime;
  List<String> notSeenUID;
  List<String> deletedUID;

  RoomMessageModel(
    this.type,
    this.content,
    this.fromUID,
    this.toRoomID,
    this.createdTime,
    this.notSeenUID,
    this.deletedUID,
  );

  RoomMessageModel copyWith({
    String? type,
    String? content,
    String? fromUID,
    String? toRoomID,
    String? createdTime,
    List<String>? notSeenUID,
    List<String>? deletedUID,
  }) {
    return RoomMessageModel(
      type ?? this.type,
      content ?? this.content,
      fromUID ?? this.fromUID,
      toRoomID ?? this.toRoomID,
      createdTime ?? this.createdTime,
      notSeenUID ?? this.notSeenUID,
      deletedUID ?? this.deletedUID,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'content': content,
      'fromUID': fromUID,
      'toRoomID': toRoomID,
      'createdTime': createdTime,
      'notSeenUID': notSeenUID,
      'deletedUID': deletedUID,
    };
  }

  factory RoomMessageModel.fromMap(Map<String, dynamic> map) {
    return RoomMessageModel(
      map['type'] ?? '',
      map['content'] ?? '',
      map['fromUID'] ?? '',
      map['toRoomID'] ?? '',
      map['createdTime'] ?? '',
      List<String>.from(map['notSeenUID']),
      List<String>.from(map['deletedUID']),
    );
  }

  String toJson() => json.encode(toMap());

  factory RoomMessageModel.fromJson(String source) =>
      RoomMessageModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RoomMessageModel(type: $type, content: $content, fromUID: $fromUID, toRoomID: $toRoomID, createdTime: $createdTime, notSeenUID: $notSeenUID, deletedUID: $deletedUID)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RoomMessageModel &&
        other.type == type &&
        other.content == content &&
        other.fromUID == fromUID &&
        other.toRoomID == toRoomID &&
        other.createdTime == createdTime &&
        listEquals(other.notSeenUID, notSeenUID) &&
        listEquals(other.deletedUID, deletedUID);
  }

  @override
  int get hashCode {
    return type.hashCode ^
        content.hashCode ^
        fromUID.hashCode ^
        toRoomID.hashCode ^
        createdTime.hashCode ^
        notSeenUID.hashCode ^
        deletedUID.hashCode;
  }
}
