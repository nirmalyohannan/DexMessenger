import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void clearChat(String recipentUID) async {
  log("Executing Clear Chat");
  String userUID = FirebaseAuth.instance.currentUser!.uid;
//----------------------------------------
  WriteBatch batch =
      FirebaseFirestore.instance.batch(); //Creating a batch for batch delete

  var ref = FirebaseFirestore.instance
      .collection('chats')
      .doc(userUID)
      .collection(recipentUID);
  var docsList = await ref.get().then((value) => value.docs);

  for (var doc in docsList) {
    //Adding documents to be deleted to the batch
    batch.delete(ref.doc(doc.id));
  }
//----------------------------------------------
  await batch
      .commit(); //Commiting all the changes added to batch(Here deletes the docs)
  await FirebaseFirestore.instance
      .collection('chats')
      .doc('recentChats')
      .collection(userUID)
      .doc(recipentUID)
      .delete();
  log("Clear Chat Completed");
}
