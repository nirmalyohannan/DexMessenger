import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/data/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendsProvider extends ChangeNotifier {
  var userUID = FirebaseAuth.instance.currentUser!.uid;

  // ignore: prefer_final_fields
  Map<String, MessageModel> _friendshipStatusMap = {};

  MessageModel? getFriendShipStatus(String recipentUID) {
    return _friendshipStatusMap[recipentUID];
  }

  List<String> getFriendsUidList() {
    List<String> friendsUidList = [];
    for (var key in _friendshipStatusMap.keys) {
      if (_friendshipStatusMap[key]!.content == 'friends') {
        if (_friendshipStatusMap[key]!.fromUID == userUID) {
          friendsUidList.add(_friendshipStatusMap[key]!.toUID);
        } else {
          friendsUidList.add(_friendshipStatusMap[key]!.fromUID);
        }
      }
    }
    return friendsUidList;
  }

  void initiate() {
    FirebaseFirestore.instance
        .collection('friends')
        .doc(userUID)
        .snapshots()
        .listen((event) {
      Map statusMaps = event.data() ?? {};

      //---------------------------------------

      for (var key in statusMaps.keys) {
        MessageModel messageModel = MessageModel.fromJson(statusMaps[key]);
        _friendshipStatusMap[key] = (messageModel);
      }

      //------------------------------
      notifyListeners();
    });
  }
}
