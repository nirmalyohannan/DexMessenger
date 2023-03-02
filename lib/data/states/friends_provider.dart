import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendsProvider extends ChangeNotifier {
  var userUID = FirebaseAuth.instance.currentUser!.uid;
  Map<String, dynamic> friendshipStatusMap = {};
  initiate() {
    FirebaseFirestore.instance
        .collection('friends')
        .doc(userUID)
        .snapshots()
        .listen((event) {
      friendshipStatusMap = event.data() ?? {};
      notifyListeners();
    });
  }
}
