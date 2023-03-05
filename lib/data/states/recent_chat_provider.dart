import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/data/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecentChatProvider extends ChangeNotifier {
  Map<String, MessageModel> recentChat = {};
  late String userUID;

  initiate() {
    userUID = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('chats')
        .doc('recentChats')
        .collection(userUID)
        .snapshots()
        .listen((event) {
      for (var element in event.docs) {
        MessageModel messageModel = MessageModel.fromJson(element.data());
        if (messageModel.fromUID == userUID) {
          recentChat[messageModel.toUID] = messageModel;
        } else {
          recentChat[messageModel.fromUID] = messageModel;
        }
      }
    });
  }

  bool isLastMessage(MessageModel messageModel) {
    String recipentUID;

    if (messageModel.fromUID == userUID) {
      recipentUID = messageModel.toUID;
    } else {
      recipentUID = messageModel.fromUID;
    }

    return recentChat[recipentUID]!.createdTime == messageModel.createdTime;
  }
}
