import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_interview/env/env.dart';

class OpenAIService {
  List<Map<String, dynamic>> messages = [];
  List<Map<String, dynamic>> answerMessages = [];

  String subject;
  // 프롬프트를 동적으로 설정
  String get finalPrompt => Env.prompt.replaceAll('#subject', subject);

  OpenAIService({required this.subject}) {
    // 시스템 메시지를 초기화 시에 설정
    messages.add({
      'role': 'system',
      'content': finalPrompt,
    });

    answerMessages.add({
      'role': 'system',
      'content': Env.answerPrompt,
    });

    // messages.add({
    //   'role': 'user',
    //   'content': Env.userPrompt,
    // });
  }

  Future<String> createModel(String sendMessage) async {
    const String apiKey = Env.apiKey;
    const String apiUrl = 'https://api.openai.com/v1/chat/completions';

    // 사용자의 새로운 메시지를 messages 리스트에 추가
    messages.add({
      'role': 'user',
      'content': sendMessage,
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': messages,
          'max_tokens': 1000,
          'temperature': 1,
          'top_p': 1,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        final String reply = data['choices'][0]['message']['content'];

        // 어시스턴트의 응답을 messages 리스트에 추가하여 대화 맥락을 유지
        messages.add({
          'role': 'assistant',
          'content': reply,
        });

        return reply;
      } else {
        return 'Error: ${response.statusCode} ${response.reasonPhrase}';
      }
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<String> createAnswerModel(String sendMessage) async {
    const String apiKey = Env.apiKey;
    const String apiUrl = 'https://api.openai.com/v1/chat/completions';

    // AI의 새로운 메시지를 answerMessages 리스트에 추가
    answerMessages.add({
      'role': 'user',
      'content': sendMessage,
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': answerMessages,
          'max_tokens': 1000,
          'temperature': 1,
          'top_p': 1,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        final String reply = data['choices'][0]['message']['content'];

        // 어시스턴트의 응답을 messages 리스트에 추가하여 대화 맥락을 유지
        answerMessages.add({
          'role': 'assistant',
          'content': reply,
        });

        return reply;
      } else {
        return 'Error: ${response.statusCode} ${response.reasonPhrase}';
      }
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  void endConversation() {
    // 대화 종료: messages 리스트를 초기화하여 이전 대화 내역 삭제 (AI 맥락 파괴)
    messages.clear();
    answerMessages.clear();
    messages.add({
      'role': 'system',
      'content': finalPrompt,
    });
    answerMessages.add({
      'role': 'system',
      'content': Env.answerPrompt,
    });
    // messages.add({
    //   'role': 'user',
    //   'content': Env.userPrompt,
    // });
  }

  // void setSubject(String newValue) {
  //   print('현재 subject: $subject');
  //   subject = newValue;
  //   print('새 subject: $subject');

  //   endConversation();
  // }

  void setSubject(String newValue) {
    subject = newValue;
    endConversation();
  }
}
