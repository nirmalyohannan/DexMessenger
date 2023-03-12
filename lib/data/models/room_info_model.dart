import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:dex_messenger/data/models/room_message_model.dart';

class RoomInfoModel {
  String imageUrl;
  String name;
  String roomID;
  List<String> membersUID;
  List<String> adminsUID;
  bool isBroadcastRoom;
  RoomMessageModel lastMessage;

  RoomInfoModel(
    this.imageUrl,
    this.name,
    this.roomID,
    this.membersUID,
    this.adminsUID,
    this.isBroadcastRoom,
    this.lastMessage,
  );

  RoomInfoModel copyWith({
    String? imageUrl,
    String? name,
    String? roomID,
    List<String>? membersUID,
    List<String>? adminsUID,
    bool? isBroadcastRoom,
    RoomMessageModel? lastMessage,
  }) {
    return RoomInfoModel(
      imageUrl ?? this.imageUrl,
      name ?? this.name,
      roomID ?? this.roomID,
      membersUID ?? this.membersUID,
      adminsUID ?? this.adminsUID,
      isBroadcastRoom ?? this.isBroadcastRoom,
      lastMessage ?? this.lastMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'name': name,
      'roomID': roomID,
      'membersUID': membersUID,
      'adminsUID': adminsUID,
      'isBroadcastRoom': isBroadcastRoom,
      'lastMessage': lastMessage.toMap(),
    };
  }

  factory RoomInfoModel.fromMap(Map<String, dynamic> map) {
    return RoomInfoModel(
      map['imageUrl'] ?? '',
      map['name'] ?? '',
      map['roomID'] ?? '',
      List<String>.from(map['membersUID']),
      List<String>.from(map['adminsUID']),
      map['isBroadcastRoom'] ?? false,
      RoomMessageModel.fromMap(map['lastMessage']),
    );
  }

  String toJson() => json.encode(toMap());

  factory RoomInfoModel.fromJson(String source) =>
      RoomInfoModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RoomInfoModel(imageUrl: $imageUrl, name: $name, roomID: $roomID, membersUID: $membersUID, adminsUID: $adminsUID, isBroadcastRoom: $isBroadcastRoom, lastMessage: $lastMessage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RoomInfoModel &&
        other.imageUrl == imageUrl &&
        other.name == name &&
        other.roomID == roomID &&
        listEquals(other.membersUID, membersUID) &&
        listEquals(other.adminsUID, adminsUID) &&
        other.isBroadcastRoom == isBroadcastRoom &&
        other.lastMessage == lastMessage;
  }

  @override
  int get hashCode {
    return imageUrl.hashCode ^
        name.hashCode ^
        roomID.hashCode ^
        membersUID.hashCode ^
        adminsUID.hashCode ^
        isBroadcastRoom.hashCode ^
        lastMessage.hashCode;
  }
}
