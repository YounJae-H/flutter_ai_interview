import 'package:flutter/material.dart';

class ScrollControllerProvider with ChangeNotifier {
  final FixedExtentScrollController _pickSubjectScrollController =
      FixedExtentScrollController(initialItem: 4);

  final FixedExtentScrollController _questionScrollController =
      FixedExtentScrollController(initialItem: 4);

  FixedExtentScrollController get pickSubjectScrollController =>
      _pickSubjectScrollController;

  FixedExtentScrollController get questionScrollController =>
      _questionScrollController;

  void setScrollController() {
    _pickSubjectScrollController.jumpToItem(4);
    _questionScrollController.jumpToItem(4);
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pickSubjectScrollController.dispose();
    _questionScrollController.dispose();
    super.dispose();
  }
}
