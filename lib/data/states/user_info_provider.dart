import 'package:flutter/material.dart';

class UserInfoProvider extends ChangeNotifier {
  String? userDpUrl;
  String? uid;
  String? userName;

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
