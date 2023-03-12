import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/data/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecentChatProvider extends ChangeNotifier {
  Map<String, MessageModel> recentChat = {};
  Map<String, String> recentChatFriendsName = {};

  late String userUID;

  initiate() {
    userUID = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('chats')
        .doc('recentChats')
        .collection(userUID)
        .snapshots()
        .listen((event) async {
      for (var element in event.docChanges) {
        MessageModel messageModel = MessageModel.fromJson(element.doc.data()!);
        if (messageModel.fromUID == userUID) {
          String recipentUID = messageModel.toUID;
          recentChat[recipentUID] = messageModel;
        } else {
          String recipentUID = messageModel.fromUID;
          recentChat[recipentUID] = messageModel;

          if (recentChatFriendsName[recipentUID] == null) {
            var recipentDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(recipentUID)
                .get();
            recentChatFriendsName[recipentUID] = recipentDoc.get('name');
          }

          // if (!isInForeground) {
          //   NotificationService.showNotification(
          //       2, recentChatFriendsName[recipentUID]!, messageModel.content);
          // }
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
