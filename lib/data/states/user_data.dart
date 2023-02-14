import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDataProvider extends ChangeNotifier {
  User? user = FirebaseAuth.instance.currentUser;

  File? userDpFile;

  set setUserDpFile(File file) {
    userDpFile = file;
    notifyListeners();
  }
}
