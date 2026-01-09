import 'package:flutter/material.dart';

class BottomNavProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void updateIndex(int newIndex) {
    if (newIndex != 2) {
      _currentIndex = newIndex;
      notifyListeners();
    }
  }
}