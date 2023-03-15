import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> refreshOnlineStatus() async {
  String userUID = FirebaseAuth.instance.currentUser!.uid;
  log('Refreshing Online Status');
  await FirebaseFirestore.instance
      .collection('lastSeen')
      .doc(userUID)
      .set({'lastSeen': DateTime.now().toUtc().toString()});
}
