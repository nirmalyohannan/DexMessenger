import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/data/models/message_model.dart';
import 'package:dex_messenger/data/states/friends_provider.dart';
import 'package:dex_messenger/utils/send_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> unfriendRecipent(BuildContext context, String recipentUID) async {
  log('Unfriending : $recipentUID');
  String userUID = FirebaseAuth.instance.currentUser!.uid;

  MessageModel messageModel = MessageModel(
      type: 'relation',
      content: 'unfriend',
      fromUID: userUID,
      toUID: recipentUID,
      createdTime: DateTime.now().toUtc().toString(),
      deliveryStatus: 'send');

//-------Setting Request in Frnds Collection------------------
  MessageModel? friendshipStatus =
      context.read<FriendsProvider>().getFriendShipStatus(recipentUID);

  if (friendshipStatus != null) {
    if (friendshipStatus.content != 'unfriend') {
      FirebaseFirestore.instance
          .collection('friends')
          .doc(userUID)
          .update({recipentUID: messageModel.toJson()});

      FirebaseFirestore.instance
          .collection('friends')
          .doc(recipentUID)
          .update({userUID: messageModel.toJson()});
      //------------------------------
      sendMessage(
          type: 'relation', content: 'unfriend', recipentUID: recipentUID);

      log('Unfriending Completed');
    } else {
      log('Unfriending Cancelled Because it is already unfriended');
    }
  } else {
    log('Unfriending Cancelled Because no existing relation between users');
  }
  // var userDoc =
  //     await FirebaseFirestore.instance.collection('friends').doc(userUID).get();
  // if (userDoc.exists) {
  //   FirebaseFirestore.instance
  //       .collection('friends')
  //       .doc(userUID)
  //       .update({recipentUID: messageModel.toJson()});
  // } else {
  //   FirebaseFirestore.instance
  //       .collection('friends')
  //       .doc(userUID)
  //       .set({recipentUID: messageModel.toJson()});
  // }
  //::
  // var recipentDoc = await FirebaseFirestore.instance
  //     .collection('friends')
  //     .doc(recipentUID)
  //     .get();
  // if (recipentDoc.exists) {
  //   FirebaseFirestore.instance
  //       .collection('friends')
  //       .doc(recipentUID)
  //       .update({userUID: messageModel.toJson()});
  // } else {
  //   FirebaseFirestore.instance
  //       .collection('friends')
  //       .doc(recipentUID)
  //       .set({userUID: messageModel.toJson()});
  // }

  // sendMessage(type: 'relation', content: 'unfriend', recipentUID: recipentUID);
}
