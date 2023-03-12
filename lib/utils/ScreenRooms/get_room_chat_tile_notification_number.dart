import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<int> getRoomChatTileNotification(String roomID) async {
  String userUID = FirebaseAuth.instance.currentUser!.uid;
  var messageDocs = await FirebaseFirestore.instance
      .collection('roomChats')
      .doc(roomID)
      .collection('messages')
      .where('notSeenUID', arrayContains: userUID)
      .get();

  return messageDocs.docs.length;
}
