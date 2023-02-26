import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/data/models/message_model.dart';
import 'package:dex_messenger/utils/ScreenHome/set_delivery_status_recieved.dart';
import 'package:firebase_auth/firebase_auth.dart';

listenMesssagesToSetRecieved() async {
  log("Started Listening messages to set Delivery Status Recieved");
  String userUID = FirebaseAuth.instance.currentUser!.uid;
  FirebaseFirestore.instance
      .collection('chats')
      .doc('recentChats')
      .collection(userUID)
      .snapshots()
      .listen((event) async {
    log('listenMesssagesToSetRecieved: New Message Detected');
    var recentChatList = event.docs;

    for (var chat in recentChatList) {
      MessageModel messageModel = MessageModel.fromJson(chat.data());
      if (messageModel.fromUID != userUID) {
        //if last message in recent chat is sendby(fromUID) user,
        // then already all messages are seen and no need to worry about setting delivery status recieved
        //so only enters this if the case is otherwise

        String recipentUID = messageModel.fromUID;
//-----------------------------------------------------------------------
        var userRecipentCollection = FirebaseFirestore.instance
            .collection('chats')
            .doc(userUID)
            .collection(recipentUID);
        var userRecipentChatDocs = await userRecipentCollection.get();

        for (var element in userRecipentChatDocs.docs) {
          MessageModel messageModel = MessageModel.fromJson(element.data());
          if (messageModel.deliveryStatus == 'send') {
            setDeliveryStatusRecieved(messageModel, recipentUID);
          }
        }
      }
    }
  });
}
