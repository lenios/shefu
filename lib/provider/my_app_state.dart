import 'package:flutter/material.dart';

class MyAppState extends ChangeNotifier {
  GlobalKey? historyListKey;

  int servings = 4;

  void setServings(int servings) {
    servings = servings;
    notifyListeners();
  }

  void getNext() {
    notifyListeners();
  }
}
