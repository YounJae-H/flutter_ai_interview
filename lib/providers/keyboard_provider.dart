import 'package:flutter/material.dart';

class KeyboardProvider with ChangeNotifier {
  double _keyboardHeight = 0.0;

  double get keyboardHeight => _keyboardHeight;

  void updateKeyboardHeight(double newHeight) {
    _keyboardHeight = newHeight;
    notifyListeners();
  }
}
