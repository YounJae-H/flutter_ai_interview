import 'package:flutter/cupertino.dart';

class ScrollControllerProvider with ChangeNotifier {
  final FixedExtentScrollController _scrollController =
      FixedExtentScrollController(initialItem: 4);

  FixedExtentScrollController get scrollController => _scrollController;

  void setScrollController() {
    _scrollController.jumpToItem(4);
    notifyListeners();
  }
}
