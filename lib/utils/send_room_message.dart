import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/data/models/room_message_model.dart';

Future<void> sendRoomMessage(RoomMessageModel roomMessageModel) async {
  var roomMessageCollection = FirebaseFirestore.instance
      .collection('roomChats')
      .doc(roomMessageModel.toRoomID)
      .collection('messages');

  var roomDoc = FirebaseFirestore.instance
      .collection('roomChats')
      .doc(roomMessageModel.toRoomID);

  log('sendRoomMessage: Sending Message to Room');
  await roomMessageCollection
      .doc(roomMessageModel.createdTime)
      .set(roomMessageModel.toMap());

  await roomDoc
      .set({'lastMessage': roomMessageModel.toMap()}, SetOptions(merge: true));
  log('sendRoomMessage: Sending Message to Room Complete');
}
