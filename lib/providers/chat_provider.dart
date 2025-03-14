import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_interview/models/chat_message.dart';
import 'package:flutter_interview/services/openai_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatProvider with ChangeNotifier {
  final List<ChatMessage> _messages = [];
  final List<List<ChatMessage>> _saveMessages = [];
  late final OpenAIService _openAIService;
  final List<String> _difficultyLevels = ['최하', '하', '중', '상', '최상'];
  String _selectedDifficulty = '중';
  String _subject;
  int _questionCount = 6; // 질문 개수 초기값
  bool _isTyping = false; // ai 타이핑 감지 - ai 응답이 전부 오기 전까지 메시지 전송을 막기 위함.
  bool _isLoading = false; // ai 응답이 오기 전까지 메시지 박스에 로딩창을 보여주기 위함.
  bool _isFirstMessage = true; // ai 생성시 첫 응답이 오기까지 화면 중앙에 로딩창을 보여주기 위함.
  bool _isEnded = false; // 면접이 종료되었는지 확인.
  bool _isLearning = false; // 학습 페이지인지 아닌지 확인.
  String answerResponse = ""; // AI 학습을 위한 응답 저장.
  bool _hasSaved = false; // 세이브 여부 상태 추가

  int get questionCount => _questionCount;
  List<String> get difficultyLevels => _difficultyLevels;
  String get selectedDifficulty => _selectedDifficulty;
  String get subject => _subject;

  List<ChatMessage> get messages => _messages;
  List<List<ChatMessage>> get saveMessages => _saveMessages;
  bool get isTyping => _isTyping;
  bool get isLoading => _isLoading;
  bool get isFirstMessage => _isFirstMessage;
  bool get isEnded => _isEnded;
  bool get isLearning => _isLearning;
  bool get hasSaved => _hasSaved; // 세이브 여부를 반환하는 getter

  ChatProvider(this._subject)
      : _openAIService = OpenAIService(subject: _subject);

  Future<void> sendMessage(String message) async {
    if (_isTyping) return;

    _addMessage(message, isUser: true);
    _setTypingState(true);
    _setLoadingState(true);

    String response;
    String response2;

    if (!((message.contains('정답') && message.length < 10) ||
        (message.contains('오답') && message.length < 10))) {
      response = await _openAIService.createModel(message);
      if (_isLearning) {
        answerResponse = await _openAIService.createAnswerModel(response);
      }

      _setLoadingState(false);
      _setIsFirstMessage(false);

      await _displayAssistantMessage(response);

      _setTypingState(false);
      checkForEndInterview();

      return;
    } else {
      response = '"$message"라는 답변은 면접 상황에서 적절하지 않습니다.';
      response2 = await _openAIService.createModel('질문이 뭐였죠?');
      _setLoadingState(false);
      _setIsFirstMessage(false);

      await _displayAssistantMessage(response);
      // await _displayAssistantMessage('다시 질문 드리겠습니다.');
      await _displayAssistantMessage(response2);

      _setTypingState(false);
      checkForEndInterview();

      return;
    }
  }

  void _addMessage(String message, {required bool isUser}) {
    _messages.add(ChatMessage(message: message, isUser: isUser));
    notifyListeners();
  }

  Future<void> _displayAssistantMessage(String message) async {
    final lines = message.split('\n').where((line) => line.trim().isNotEmpty);
    for (String line in lines) {
      final index = _messages.length;
      _addMessage('', isUser: false);
      await _animateAssistantResponse(line, index);
    }
  }

  Future<void> _animateAssistantResponse(String line, int index) async {
    for (int i = 0; i < line.length; i++) {
      await Future.delayed(const Duration(milliseconds: 2));
      _messages[index] =
          ChatMessage(message: line.substring(0, i + 1), isUser: false);
      notifyListeners();
    }
    await Future.delayed(const Duration(milliseconds: 10));
  }

  void _setTypingState(bool isTyping) {
    _isTyping = isTyping;
    notifyListeners();
  }

  void _setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void _setIsFirstMessage(bool isFirstMessage) {
    _isFirstMessage = isFirstMessage;
    notifyListeners();
  }

  void setIsLearning(bool isLearning) {
    _isLearning = isLearning;
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
    save();
    // 대화 종료: messages 리스트를 초기화하여 이전 대화 내역 삭제 (화면에 표시하는 대회 내역 삭제)
    _messages.clear(); // 화면 표시 대화 내역 삭제
    _openAIService.endConversation(); //OpenAI 기존 맥락 파괴 후 초기화
    answerResponse = ""; // Ai 학습 응답 초기화
    _setIsFirstMessage(true); // 모델 생성시 첫 메시지 응답이 오는 동안 로딩창을 보여주기 위함
    _hasSaved = false; // save 여부
    _isEnded = false; // 면접 종료 여부
    notifyListeners();
  }

  void checkForEndInterview() {
    for (var msg in _messages) {
      if (!msg.isUser && msg.message.contains('면접이 종료되었습니다.')) {
        _isEnded = true; // 조건이 만족되었으므로 true
        return;
      }
    }
    _isEnded = false; // 조건이 만족되지 않았으므로 false
  }

  void setSubject(String newValue) {
    _subject = newValue;
    _openAIService.setSubject(_subject);
    notifyListeners();
  }

  // void save() {
  //   final messagesToSave = _messages;
  //   messagesToSave.removeAt(0);
  //   _saveMessages.add(List<ChatMessage>.from(messagesToSave));
  //   _hasSaved = true; // 세이브 후 상태 변경
  //   notifyListeners();
  // }
  Future<void> save() async {
    final author = Supabase.instance.client.auth.currentUser?.id;
    final messagesToSave = _messages;
    messagesToSave.removeAt(0); // 필요에 따라 첫 번째 메시지를 제외
    _saveMessages.add(List<ChatMessage>.from(messagesToSave)); //로컬에 저장

    final response = await Supabase.instance.client // Supabase에 저장
        .from('chatMessage') // Supabase에 생성한 테이블 이름
        .insert({
      'author': author,
      'message': messagesToSave.map((m) => m.toMap()).toList(), // 메시지 내용을 변환
      'created_at': DateTime.now().toIso8601String(), // 생성 시간
    });

    _hasSaved = true;

    notifyListeners();
  }

  // List<ChatMessage> getSavedMessages(int index) {
  //   return _saveMessages.elementAt(index).toList();
  // }

  // Future<Map<String, dynamic>> getSavedMessages(
  //     String userId, int index) async {
  //   final response = await Supabase.instance.client
  //       .from('chatMessage')
  //       .select('message, created_at')
  //       .eq('author', userId)
  //       .order('created_at', ascending: false); // 내림차순

  //   // 날짜 변환
  //   final time = response[index]['created_at'] as String;

  //   // 메시지 처리
  //   final jsonString = response[index]['message'] as String;
  //   final List<dynamic> data = jsonDecode(jsonString);
  //   final messages = data.map((json) => ChatMessage.fromMap(json)).toList();

  //   return {'messages': messages, 'time': time};
  // }

  Future<List<Map<String, dynamic>>> getAllSavedMessages(
      String userId, int messageCount) async {
    final response = await Supabase.instance.client
        .from('chatMessage')
        .select('message, created_at')
        .eq('author', userId)
        .order('created_at', ascending: false); // 내림차순

    // 데이터 처리
    List<Map<String, dynamic>> allMessages = [];
    for (int i = 0; i < messageCount; i++) {
      final time = response[i]['created_at'] as String;
      final jsonString = response[i]['message'] as String;
      final List<dynamic> data = jsonDecode(jsonString);
      final messages = data.map((json) => ChatMessage.fromMap(json)).toList();

      allMessages.add({'messages': messages, 'time': time});
    }
    return allMessages;
  }

  void deleteSavedMessages(int index) {
    _saveMessages.removeAt(index);
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    endInterview();
    super.dispose();
  }
}
