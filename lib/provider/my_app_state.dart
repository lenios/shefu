import 'package:flutter/material.dart';

class MyAppState extends ChangeNotifier {
  GlobalKey? historyListKey;

  int servings = 4;

  void setServings(int newServings) {
    servings = newServings;
    notifyListeners();
  }

  void getNext() {
    notifyListeners();
  }
}
