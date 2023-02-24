import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/data/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

void sendMessage({required String content, required String recipentUID}) {
  //--------------------------------

  //-------------------------------
  var userUID = FirebaseAuth.instance.currentUser!.uid;
  //-----------------
  MessageModel messageModel = MessageModel(
      type: 'string',
      content: content,
      fromUID: userUID,
      toUID: recipentUID,
      createdTime: DateTime.now().toString());
  //---------------------
  var chatsCollectionRef = FirebaseFirestore.instance.collection('chats');
  var recentChatsDocRef =
      FirebaseFirestore.instance.collection('chats').doc('recentChats');
  //---------------
  log('UserUID: $userUID');
  log('recipentUID: $recipentUID');

  var userRecipentChatCollecRef =
      chatsCollectionRef.doc(userUID).collection(recipentUID);
  // var userRecipentChatDoc = await userRecipentChatCollecRef.get();
  //------------
  var recipentUserChatCollecRef =
      chatsCollectionRef.doc(recipentUID).collection(userUID);
  // var recipentUserChatDoc = await recipentUserChatCollecRef.get();
  //--------------------------------------
  //----Adding the Message to user's and recipent's message collection in Firestore Database
  userRecipentChatCollecRef.add(messageModel.toJson());
  recentChatsDocRef
      .collection(userUID)
      .doc(recipentUID)
      .set(messageModel.toJson());

  recipentUserChatCollecRef.add(messageModel.toJson());
  recentChatsDocRef
      .collection(recipentUID)
      .doc(userUID)
      .set(messageModel.toJson());
}
