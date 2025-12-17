import 'package:flutter/cupertino.dart';

class BottomNavProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  // Hàm cập nhật giá trị index
  void updateIndex(int newIndex) {
    _currentIndex = newIndex;
    notifyListeners();
  }
}