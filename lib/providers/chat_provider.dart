import 'package:flutter/material.dart';
import 'package:flutter_interview/models/chat_message.dart';
import 'package:flutter_interview/services/openai_service.dart';
import 'package:go_router/go_router.dart';

class ChatProvider with ChangeNotifier {
  final List<ChatMessage> _messages = [];
  final OpenAIService _openAIService = OpenAIService();
  final List<String> _difficulty = ['최하', '하', '중', '상', '최상'];
  String _selectedDifficulty = '중';
  int _questionCount = 6; // 질문 개수 초기값
  bool _isTyping = false; // ai 타이핑 감지 - ai 응답이 전부 오기 전까지 메시지 전송을 막기 위함.
  bool _isLoading = false; // ai 응답이 오기 전까지 메시지 박스에 로딩창을 보여주기 위함.
  bool _isFirstMessage = true; // ai 생성시 첫 응답이 오기까지 화면 중앙에 로딩창을 보여주기 위함
  bool _isInterviewEnded = false; // 면접이 종료되었는지 확인

  int get questionCount => _questionCount;
  List<String> get difficulty => _difficulty;
  String get selectedDifficulty => _selectedDifficulty;

  List<ChatMessage> get messages => _messages;
  bool get isTyping => _isTyping;
  bool get isLoading => _isLoading;
  bool get isFirstMessage => _isFirstMessage;
  bool get isInterviewEnded => _isInterviewEnded;

  Future<void> sendMessage(String message) async {
    if (_isTyping) return;

    _addMessage(message, isUser: true);

    _setTypingState(true);
    _setLoadingState(true);

    String response = await _openAIService.createModel(message);
    _setLoadingState(false);
    _setisFirstMessage(false);
    await _displayAssistantMessage(response);

    checkForEndInterview();
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
        await Future.delayed(const Duration(milliseconds: 2));
        _messages[index] =
            ChatMessage(message: line.substring(0, i + 1), isUser: false);
        notifyListeners();
      }
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }

  void _setTypingState(bool isTyping) {
    _isTyping = isTyping;
    notifyListeners();
  }

  void _setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void _setisFirstMessage(bool isFirstMessage) {
    _isFirstMessage = isFirstMessage;
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
    _setisFirstMessage(true); // 모델 생성시 첫 메시지 응답이 오는 동안 로딩창을 보여주기 위함
    _isInterviewEnded = false; // 면접 종료 여부
    notifyListeners();
  }

  void checkForEndInterview() {
    for (var msg in _messages) {
      if (!msg.isUser && msg.message.contains('종료')) {
        _isInterviewEnded = true; // 조건이 만족되었으므로 true
        return;
      }
    }
    _isInterviewEnded = false; // 조건이 만족되지 않았으므로 false
  }
}
