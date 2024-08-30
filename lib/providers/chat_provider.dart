import 'package:flutter/material.dart';
import 'package:flutter_interview/models/chat_message.dart';
import 'package:flutter_interview/services/openai_service.dart';

class ChatProvider with ChangeNotifier {
  final List<ChatMessage> _messages = [];
  final OpenAIService _openAIService = OpenAIService();
  late int _qCount;
  bool _isTyping = false;

  int get qCount => _qCount;
  List<ChatMessage> get messages => _messages;
  bool get isTyping => _isTyping;

  ChatProvider() {
    _qCount = 4;
  }

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
}
