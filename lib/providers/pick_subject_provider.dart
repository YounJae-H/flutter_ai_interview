import 'package:flutter/material.dart';

class PickSubjectProvider with ChangeNotifier {
  final List<String> _subjectList = [
    '간호사',
    '의사',
    '약사',
    '검사',
    '변호사',
    '회계사',
    '직업 상담사',
    '심리 상담사',
    '수학 교사',
  ];
  String _pickSubject = "변호사";
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
