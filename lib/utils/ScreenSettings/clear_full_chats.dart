import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> clearFullChats() async {
  log('Clearing Full chats started');
  String userUID = FirebaseAuth.instance.currentUser!.uid;
  WriteBatch batch = FirebaseFirestore.instance.batch();
  List<String> recipentUIDList = [];

  var recentChatDocs = await FirebaseFirestore.instance
      .collection('chats')
      .doc('recentChats')
      .collection(userUID)
      .get()
      .then((value) => value.docs);

  for (var element in recentChatDocs) {
    recipentUIDList.add(element.id);
    batch.delete(element.reference);
  }

  for (var recipentUID in recipentUIDList) {
    var docsSnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .doc(userUID)
        .collection(recipentUID)
        .get();

    for (var element in docsSnapshot.docs) {
      batch.delete(element.reference);
    }
  }
  //-------------------------------------
  var userChatDocRef =
      FirebaseFirestore.instance.collection('chats').doc(userUID);
  batch.delete(userChatDocRef);
  //----------------------------------------

  await batch.commit();

  //---------------------------------------
  log('Clearing Full chats completed');
}
