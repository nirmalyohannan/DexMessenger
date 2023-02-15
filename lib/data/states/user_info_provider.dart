import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserInfoProvider extends ChangeNotifier {
  User? user = FirebaseAuth.instance.currentUser;

  File? userDpFile;

  String? uid;
  String? userName;

  set setUserName(String name) {
    userName = name;
    notifyListeners();
  }

  set setUserDpFile(File file) {
    userDpFile = file;
    notifyListeners();
  }
}
