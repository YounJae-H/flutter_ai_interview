import 'package:flutter/material.dart';

class PickSubjectProvider with ChangeNotifier {
  final List<String> _subjectList = [
    'Android',
    'Swift/iOS',
    'React',
    'ReactNative',
    'Java',
    'JavaScript',
    'React',
    'Spring',
    'Unity',
  ];
  String _pickSubject = "Java";
  // String _subject = "Flutter";

  final TextEditingController _textEditingController = TextEditingController();

  TextEditingController get textEditingController => _textEditingController;

  List<String> get subjectList => _subjectList;

  String get pickSubject => _pickSubject;

  // String get subject => _subject;

  void setSubject(String newValue) {
    _pickSubject = newValue;

    notifyListeners(); // 리스너들에게 변경 사항 알림
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textEditingController.dispose();
    super.dispose();
  }
}
