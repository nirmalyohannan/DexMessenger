import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/data/states/user_info_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void listenUserInfo(BuildContext context) {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  FirebaseFirestore.instance.collection('users').doc(uid).snapshots().listen(
    (event) {
      log("listenUserInfo: Change Found");
      context.read<UserInfoProvider>().setUserName = event.data()!['name'];
      context.read<UserInfoProvider>().setUID = event.data()!['uid'];
      context.read<UserInfoProvider>().setUserDpUrl = event.data()!['image'];
    },
  );
}
