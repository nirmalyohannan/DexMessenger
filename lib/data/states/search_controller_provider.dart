import 'package:flutter/material.dart';

class SearchControllerProvider extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();

  void clear() {
    searchController.clear();
    notifyListeners();
  }

  void notify() {
    super.notifyListeners();
  }
}
