import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_interview/env/env.dart';

class OpenAIService {
  List<Map<String, dynamic>> messages = [];

  OpenAIService() {
    // 시스템 메시지를 초기화 시에 설정
    messages.add({
      'role': 'system',
      'content': Env.prompt,
    });

    messages.add({
      'role': 'user',
      'content': Env.userPrompt,
    });
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

  void endConversation() {
    // 대화 종료: messages 리스트를 초기화하여 이전 대화 내역 삭제
    messages = [];
    // 종료 메시지를 원한다면 아래 내용을 추가
    messages.add({
      'role': 'system',
      'content': '대화가 종료되었습니다. 새로운 대화를 시작하려면 메시지를 입력하세요.',
    });
  }
}
