import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/data/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

setDeliveryStatusSeen(MessageModel messageModel, String recipentUID) {
  String userUID = FirebaseAuth.instance.currentUser!.uid;

  if (userUID == messageModel.toUID && messageModel.deliveryStatus != 'seen') {
    messageModel.deliveryStatus = 'seen';
    var chatsCollectionRef = FirebaseFirestore.instance.collection('chats');
    var recentChatsDocRef =
        FirebaseFirestore.instance.collection('chats').doc('recentChats');
    //---------------

    var userRecipentChatCollecRef =
        chatsCollectionRef.doc(userUID).collection(recipentUID);
    // var userRecipentChatDoc = await userRecipentChatCollecRef.get();
    //------------
    var recipentUserChatCollecRef =
        chatsCollectionRef.doc(recipentUID).collection(userUID);
    // var recipentUserChatDoc = await recipentUserChatCollecRef.get();
    //--------------------------------------
    //----Adding the Message to user's and recipent's message collection in Firestore Database
    userRecipentChatCollecRef
        .doc(messageModel.createdTime)
        .set(messageModel.toJson());
    recentChatsDocRef
        .collection(userUID)
        .doc(recipentUID)
        .set(messageModel.toJson());

    recipentUserChatCollecRef
        .doc(messageModel.createdTime)
        .set(messageModel.toJson());
    recentChatsDocRef
        .collection(recipentUID)
        .doc(userUID)
        .set(messageModel.toJson());
  }
}
