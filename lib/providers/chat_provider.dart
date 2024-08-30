import 'package:flutter/material.dart';
import 'package:flutter_interview/models/chat_message.dart';
import 'package:flutter_interview/services/openai_service.dart';

class ChatProvider with ChangeNotifier {
  final List<ChatMessage> _messages = [];
  final OpenAIService _openAIService = OpenAIService();
  int _questionCount = 0;
  List<String> _difficulty = ['최하', '하', '중', '상', '최상'];
  String _selectedDifficulty = '중';
  bool _isTyping = false;

  int get questionCount => _questionCount;
  List<String> get difficulty => _difficulty;
  String get selectedDifficulty => _selectedDifficulty;

  List<ChatMessage> get messages => _messages;
  bool get isTyping => _isTyping;

  Future<void> sendMessage(String message) async {
    if (_isTyping) return;

    _addMessage(message, isUser: true);
    _setTypingState(true);

    String response = await _openAIService.createModel(message);
    await _displayAssistantMessage(response);

    _setTypingState(false);
  }

  void _addMessage(String message, {required bool isUser}) {
    _messages.add(ChatMessage(message: message, isUser: isUser));
    notifyListeners();
  }

  Future<void> _displayAssistantMessage(String message) async {
    //message
    final lines = message.split('\n').where((line) => line.trim().isNotEmpty);

    for (String line in lines) {
      final index = _messages.length;
      _addMessage('', isUser: false);

      for (int i = 0; i < line.length; i++) {
        await Future.delayed(Duration(milliseconds: 2));
        _messages[index] =
            ChatMessage(message: line.substring(0, i + 1), isUser: false);
        notifyListeners();
      }
      await Future.delayed(Duration(milliseconds: 10));
    }
  }

  void _setTypingState(bool isTyping) {
    _isTyping = isTyping;
    notifyListeners();
  }

  void updateQuestionCount(int newValue) {
    _questionCount = newValue;
    notifyListeners();
  }

  void updateQuestionDifficulty(String newValue) {
    _selectedDifficulty = newValue;
    notifyListeners();
  }

  void endInterview() {
    // 대화 종료: messages 리스트를 초기화하여 이전 대화 내역 삭제 (화면에 표시하는 대회 내역 삭제)
    _messages.clear(); // 화면 표시 대화 내역 삭제
    _openAIService.endConversation(); //OpenAI 기존 맥락 파괴 후 초기화
    notifyListeners();
  }
}
