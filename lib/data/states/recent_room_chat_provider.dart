import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/data/models/room_info_model.dart';
import 'package:dex_messenger/data/models/room_message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecentRoomChatProvider extends ChangeNotifier {
  Map<String, RoomInfoModel> roomInfoModelMap = {};
  String userUID = FirebaseAuth.instance.currentUser!.uid;

//---------------

//------------------------------
  void initiating() async {
    log('RecentRoomChatProvider: Initiating');
    FirebaseFirestore.instance
        .collection('roomChats')
        .where('membersUID', arrayContains: userUID)
        .snapshots()
        .listen((event) {
      for (var doc in event.docs) {
        RoomInfoModel roomInfoModel = RoomInfoModel.fromMap(doc.data());

        roomInfoModelMap[roomInfoModel.roomID] = roomInfoModel;
      }
    });
  }

//---------------------
  bool isLastMessage(RoomMessageModel messageModel) {
    return (roomInfoModelMap[messageModel.toRoomID]!.lastMessage.createdTime ==
        messageModel.createdTime);
  }

  //-------------------

  //------------------
}
