import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/data/models/story_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

Future<void> deleteStory(
    BuildContext context, SingleStoryModel singleStoryModel) async {
  log('Deleting Story');
  //------------------------------------------------
  Navigator.pop(context);
  showSimpleNotification(const Text('Deleting the Story'),
      trailing: const CircularProgressIndicator());
  //-----------------

  String userUID = FirebaseAuth.instance.currentUser!.uid;
  await FirebaseFirestore.instance.collection('stories').doc(userUID).update({
    'storiesList': FieldValue.arrayRemove([singleStoryModel.toMap()])
  });
  try {
    await FirebaseStorage.instance.refFromURL(singleStoryModel.url).delete();
  } catch (e) {
    log('DeleteStory ${e.toString()}');
  }
}
