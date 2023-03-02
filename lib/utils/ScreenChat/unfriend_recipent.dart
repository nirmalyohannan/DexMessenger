import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/data/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> unfriendRecipent(String recipentUID) async {
  log('Unfriending : $recipentUID');
  String userUID = FirebaseAuth.instance.currentUser!.uid;

  MessageModel messageModel = MessageModel(
      type: 'friendship',
      content: 'unfriend',
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

  log('Unfriending Completed');
}
