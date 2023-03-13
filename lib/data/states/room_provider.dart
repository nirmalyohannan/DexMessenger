import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/data/models/room_info_model.dart';
import 'package:dex_messenger/data/models/room_message_model.dart';
import 'package:dex_messenger/utils/ScreenHome/get_recipent_Info.dart';
import 'package:dex_messenger/utils/send_room_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:overlay_support/overlay_support.dart';

class RoomProvider extends ChangeNotifier {
  String userUID = FirebaseAuth.instance.currentUser!.uid;
  File? dpFile;
  String? roomName;
  bool isBroadcastRoom = false;
  String? dpUrl;
  bool isUploadingDP = false;
  String? roomID;

  set setDpFile(File file) {
    dpFile = file;
    notifyListeners();
  }

  void init() {
    log("Create Room Provider: Initiating");
    dpFile = null;
    roomName = null;
    isBroadcastRoom = false;
    dpUrl = null;
    isUploadingDP = false;
    roomID = FirebaseFirestore.instance.collection('roomChats').doc().id;
    notifyListeners();
  }

  bool validateRoomDetails() {
    if (dpUrl == null) {
      log('CreateRoom: Validation failed dpUrl NUll');
      return false;
    } else if (dpFile == null) {
      log('CreateRoom: Validation failed dpFile Null');
      return false;
    } else if (roomName == null) {
      log('CreateRoom: Validation failed roomNameNull');
      return false;
    } else if (roomName!.isEmpty) {
      log('CreateRoom: Validation failed roomNameEmpty');
      return false;
    }
    return true;
  }

  Future<String?> uploadDp() async {
    if (dpFile != null) {
      isUploadingDP = true;
      notifyListeners();
      var dpStorageRef =
          FirebaseStorage.instance.ref().child('roomDPs/$roomID.jpeg');
      //---Compresses Image-----------------
      dpFile = await FlutterNativeImage.compressImage(dpFile!.path);
      //-----------------------------
      var uploadTask = await dpStorageRef.putFile(dpFile!);
      isUploadingDP = false;
      notifyListeners();
      return uploadTask.ref.getDownloadURL();
    } else {
      log('Dp trying to upload is Null');
      return await null;
    }
  }

  Future<void> changeRoomName(String roomName, String roomID) async {
    log('Changing roomName');
    await FirebaseFirestore.instance
        .collection('roomChats')
        .doc(roomID)
        .update({'name': roomName});

    RoomMessageModel roomMessageModel = RoomMessageModel(
        'roomActivity',
        'Changed Room Name to $roomName',
        userUID,
        roomID,
        DateTime.now().toUtc().toString(), [], []);
    await sendRoomMessage(roomMessageModel);
    log('Changing Room name Complete');
  }

//-----------------------------------------------
  Future<RoomInfoModel?> createRoom() async {
    if (validateRoomDetails()) {
      var roomDoc =
          FirebaseFirestore.instance.collection('roomChats').doc(roomID);

      RoomMessageModel roomMessageModel = RoomMessageModel(
          'roomActivity',
          'createdRoom',
          userUID,
          roomID!,
          DateTime.now().toUtc().toString(),
          [userUID],
          []);

      RoomInfoModel roomInfoModel = RoomInfoModel(dpUrl!, roomName!, roomID!,
          [userUID], [userUID], isBroadcastRoom, roomMessageModel);

      await roomDoc.set(roomInfoModel.toMap());

      await sendRoomMessage(roomMessageModel);
      notifyListeners();
      return roomInfoModel;
    }
    notifyListeners();
    return null;
  }

//------------
  Future<void> exitFromRoom(String roomID) async {
    await FirebaseFirestore.instance
        .collection('roomChats')
        .doc(roomID)
        .update({
      'membersUID': FieldValue.arrayRemove([userUID])
    });
    await FirebaseFirestore.instance
        .collection('roomChats')
        .doc(roomID)
        .update({
      'adminsUID': FieldValue.arrayRemove([userUID])
    });
    showSimpleNotification(const Text('You have exited from the Room'),
        autoDismiss: true);
  }

  //--------------------------------------------
  Future<void> addMember(String memberUID, String roomID) async {
    log('Adding Member');
    await FirebaseFirestore.instance
        .collection('roomChats')
        .doc(roomID)
        .update({
      'membersUID': FieldValue.arrayUnion([memberUID])
    });

    var memberInfo = await getRecipentInfo(memberUID);
    RoomMessageModel roomMessageModel = RoomMessageModel(
        'roomActivity',
        'Added ${memberInfo.recipentName} to Room',
        userUID,
        roomID,
        DateTime.now().toUtc().toString(), [], []);
    await sendRoomMessage(roomMessageModel);
    log('Adding Member to the Room Complete');
  }

  //-------------------------------------------
  Future<void> removeMember(String memberUID, String roomID) async {
    log('Removing Member');
    await FirebaseFirestore.instance
        .collection('roomChats')
        .doc(roomID)
        .update({
      'membersUID': FieldValue.arrayRemove([memberUID])
    });

    var memberInfo = await getRecipentInfo(memberUID);
    RoomMessageModel roomMessageModel = RoomMessageModel(
        'roomActivity',
        'removed ${memberInfo.recipentName} from the Room',
        userUID,
        roomID,
        DateTime.now().toUtc().toString(), [], []);
    await sendRoomMessage(roomMessageModel);
    log('Removing Member from the Room Complete');
  }

  //----------------------------------------
  Future<void> addAdmin(String memberUID, String roomID) async {
    log('Adding Admin');
    await FirebaseFirestore.instance
        .collection('roomChats')
        .doc(roomID)
        .update({
      'adminsUID': FieldValue.arrayUnion([memberUID])
    });

    var memberInfo = await getRecipentInfo(memberUID);
    RoomMessageModel roomMessageModel = RoomMessageModel(
        'roomActivity',
        'Added ${memberInfo.recipentName} to Admins',
        userUID,
        roomID,
        DateTime.now().toUtc().toString(), [], []);
    await sendRoomMessage(roomMessageModel);
    log('Adding Admin to the Room Complete');
  }

  //----------------------------------
  Future<void> removeAdmin(String memberUID, String roomID) async {
    log('Removing Admin');
    await FirebaseFirestore.instance
        .collection('roomChats')
        .doc(roomID)
        .update({
      'adminsUID': FieldValue.arrayRemove([memberUID])
    });

    var memberInfo = await getRecipentInfo(memberUID);
    RoomMessageModel roomMessageModel = RoomMessageModel(
        'roomActivity',
        'Removed ${memberInfo.recipentName} from Admins',
        userUID,
        roomID,
        DateTime.now().toUtc().toString(), [], []);
    await sendRoomMessage(roomMessageModel);
    log('Removing Admin to the Room Complete');
  }
}
