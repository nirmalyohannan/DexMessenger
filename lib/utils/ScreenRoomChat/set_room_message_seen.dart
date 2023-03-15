import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/data/models/room_message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> setRoomMessageSeen(RoomMessageModel roomMessageModel) async {
  String userUID = FirebaseAuth.instance.currentUser!.uid;

  if (roomMessageModel.notSeenUID.contains(userUID)) {
    await FirebaseFirestore.instance
        .collection('roomChats')
        .doc(roomMessageModel.toRoomID)
        .collection('messages')
        .doc(roomMessageModel.createdTime)
        .update({
      'notSeenUID': FieldValue.arrayRemove([userUID])
    });
  }
}
