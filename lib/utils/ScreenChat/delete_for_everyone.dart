import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/data/models/message_model.dart';

deleteForEveryone(MessageModel messageModel, String recipentUID) async {
  log("Delete for Everyone called");

  await FirebaseFirestore.instance
      .collection('chats')
      .doc(recipentUID)
      .collection(messageModel.fromUID) //FromUID will be of the user
      .doc(messageModel.createdTime)
      .delete();

  await FirebaseFirestore.instance
      .collection('chats')
      .doc(messageModel.fromUID) //FromUID will be of the user
      .collection(recipentUID)
      .doc(messageModel.createdTime)
      .delete();

  log("Delete for everyone completed");
}
