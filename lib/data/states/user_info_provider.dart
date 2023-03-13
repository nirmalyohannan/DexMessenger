import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/data/models/recipent_info_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class UserInfoProvider extends ChangeNotifier {
  String? userDpUrl;
  String? uid;
  String? userName;
  File? userDpFile;

  bool isUploadingDp = false;

  void readUserInfo(String userUID) async {
    var userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userUID).get();
    if (userDoc.exists) {
      RecipentInfoModel userInfo = RecipentInfoModel.fromJson(userDoc.data()!);
      userDpUrl = userInfo.recipentDpUrl;
      userName = userInfo.recipentName;
      uid = userUID;
    } else {
      var user = FirebaseAuth.instance.currentUser!;
      userName = user.displayName;
      userDpUrl = user.photoURL;
      uid = userUID;
    }
    notifyListeners();
  }

  uploadDP(File imageFile) async {
    isUploadingDp = true;
    notifyListeners();
    String userUID = FirebaseAuth.instance.currentUser!.uid;
    var storageRef = FirebaseStorage.instance.ref().child('dp/$userUID.jpeg');
    //---Compresses Image-----------------
    imageFile = await FlutterNativeImage.compressImage(imageFile.path);
    //-----------------------------
    log("Going to Upload Dp File");
    var uploadTask = await storageRef.putFile(imageFile);
    log("Upload Dp File Completed");

    isUploadingDp = false;
    userDpUrl = await uploadTask.ref.getDownloadURL();
    notifyListeners();
  }

  set setUserDpFile(File file) {
    userDpFile = file;
    notifyListeners();
  }

  set setUserName(String name) {
    userName = name;
    notifyListeners();
  }

  set setUID(String newUID) {
    uid = newUID;
    notifyListeners();
  }

  set setUserDpUrl(String url) {
    userDpUrl = url;
    notifyListeners();
  }

  void clear() {
    userDpUrl = null;
    uid = null;
    userName = null;
    notifyListeners();
  }
}
