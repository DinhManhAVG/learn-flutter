import 'package:flutter/material.dart';

// ChangeNotifier là một class đặc biệt của Flutter 
// giúp thông báo cho các "người nghe" (listeners) khi có sự thay đổi.
class NavigationProvider with ChangeNotifier {
  int _currentIndex = 0;
  
  int get currentIndex => _currentIndex;

  void changeIndex(int newIndex) {
    _currentIndex = newIndex;

    notifyListeners();
  }
}