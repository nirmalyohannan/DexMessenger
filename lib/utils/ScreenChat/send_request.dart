import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/data/models/message_model.dart';
import 'package:dex_messenger/utils/send_message.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> sendRequest(String recipentUID) async {
  log('Sending Friend Request to: $recipentUID');
  String userUID = FirebaseAuth.instance.currentUser!.uid;

  MessageModel messageModel = MessageModel(
      type: 'relation',
      content: 'requested',
      fromUID: userUID,
      toUID: recipentUID,
      createdTime: DateTime.now().toUtc().toString(),
      deliveryStatus: 'send');

//-------Setting Request in Frnds Collection------------------
  var userDoc =
      await FirebaseFirestore.instance.collection('friends').doc(userUID).get();
  if (userDoc.exists) {
    FirebaseFirestore.instance
        .collection('friends')
        .doc(userUID)
        .update({recipentUID: messageModel.toJson()});
  } else {
    FirebaseFirestore.instance
        .collection('friends')
        .doc(userUID)
        .set({recipentUID: messageModel.toJson()});
  }
  //::
  var recipentDoc = await FirebaseFirestore.instance
      .collection('friends')
      .doc(recipentUID)
      .get();
  if (recipentDoc.exists) {
    FirebaseFirestore.instance
        .collection('friends')
        .doc(recipentUID)
        .update({userUID: messageModel.toJson()});
  } else {
    FirebaseFirestore.instance
        .collection('friends')
        .doc(recipentUID)
        .set({userUID: messageModel.toJson()});
  }

  //-----------Sending Request as a message to chats & Recent Chats---------------------

  sendMessage(type: 'relation', content: 'requested', recipentUID: recipentUID);

  log('Sending Friend Request Comepleted');
}
