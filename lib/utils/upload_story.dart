import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/data/models/story_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

Future<void> uploadStory(File file) async {
  log('Uploading Story');

  //---Compresses Image-----------------
  file = await FlutterNativeImage.compressImage(file.path);
  //-----------------------------
  String userUID = FirebaseAuth.instance.currentUser!.uid;
  String dateTimeString = DateTime.now().toUtc().toString();
  var storageRef = FirebaseStorage.instance
      .ref()
      .child('stories/$userUID/$dateTimeString.jpeg');
  await storageRef.putFile(file);
  String url = await storageRef.getDownloadURL();
//--------------------------

  SingleStoryModel singleStoryModel =
      SingleStoryModel(url: url, createdTime: dateTimeString);

  await FirebaseFirestore.instance.collection('stories').doc(userUID).set({
    'uid': userUID,
    'storiesList': FieldValue.arrayUnion([singleStoryModel.toMap()])
  }, SetOptions(merge: true));
  log('Uploading Story  Complete');
}
