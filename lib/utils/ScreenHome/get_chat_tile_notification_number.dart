//Gets number of notifications for a chat tile

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/data/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<int> getChatTileNotificationNumber({required String recipentUID}) async {
  int notificationNumber = 0;
  String userUID = FirebaseAuth.instance.currentUser!.uid;

  var chatCollection = await FirebaseFirestore.instance
      .collection('chats')
      .doc(userUID)
      .collection(recipentUID)
      .orderBy('createdTime', descending: true)
      .get();

  for (var element in chatCollection.docs) {
    MessageModel messageModel = MessageModel.fromJson(element.data());

    if (messageModel.toUID == userUID) {
      if (messageModel.deliveryStatus == 'recieved') {
        notificationNumber++;
      } else {
        //if deliveredStatus of message is other than recieved that means it is seen
        //If message with deliverystatus seen in reached in the loop that means all remaining messages will
        //also be seen. So no need to check the remaining messages. just return the current value.
        return notificationNumber;
      }
    }
  }
  return notificationNumber;
}
