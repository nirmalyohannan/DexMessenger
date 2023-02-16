import 'dart:io';

import 'package:flutter/material.dart';

class UserInfoProvider extends ChangeNotifier {
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

  void clear() {
    userDpFile = null;
    uid = null;
    userName = null;
    notifyListeners();
  }
}
