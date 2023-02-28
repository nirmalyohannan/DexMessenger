import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/data/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> deleteForMe(MessageModel messageModel, String recipentUID) async {
  log("Delete for Me called");
  String userUID = FirebaseAuth.instance.currentUser!.uid;

  await FirebaseFirestore.instance
      .collection('chats')
      .doc(userUID)
      .collection(recipentUID)
      .doc(messageModel.createdTime)
      .delete();

  log("Delete For me Completed");
}
