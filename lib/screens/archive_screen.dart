import 'package:flutter/material.dart';
import 'package:flutter_interview/color/colors.dart';
import 'package:flutter_interview/component/interview_item.dart';
import 'package:flutter_interview/models/chat_message.dart';
import 'package:flutter_interview/providers/chat_provider.dart';
import 'package:flutter_interview/widgets/message_item.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    return FutureBuilder<Map<String, dynamic>>(
        // ListView.builder itemCount에 직접 비동기 작업을 할 수 없기 때문에 FutureBuilder 사용해서 가져오는 것.
        future: getMessageCount(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // 로딩 중일 때
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // 오류 발생 시
          } else if (!snapshot.hasData) {
            return const Center(child: Text('저장된 면접 기록이 없습니다.')); // 메시지가 없을 때
          } else {
            final messageCount = snapshot.data!['count'];
            final userId = snapshot.data!['userId'];

            return ListView.builder(
              itemCount: messageCount,
              itemBuilder: (context, index) {
                final int getReverseListIndex =
                    messageCount - index; // 리스트 역순 배치
                return FutureBuilder<Map<String, dynamic>>(
                  future: chatProvider.getSavedMessages(userId, index),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('면접 기록이 저장되지 않았습니다.'));
                    } else {
                      final savedMessages = snapshot.data!['messages'];
                      final savedTime = snapshot.data!['time'];

                      final String title = '면접 기록 $getReverseListIndex';

                      return Column(
                        children: [
                          Card(
                            elevation: 5,
                            color: Colors.white,
                            child: InterviewItem(
                              title: title,
                              createdAt: savedTime,
                              onPressed: () {
                                context.push('/save',
                                    extra: [savedMessages, title]);
                              },
                              buttonEnable: false,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                );
              },
            );
          }
        });
  }

  Future<Map<String, dynamic>> getMessageCount() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    final response = await Supabase.instance.client
        .from('chatMessage')
        .select('*')
        .eq('author', userId!)
        .count();

    return {'count': response.count, 'userId': userId};
  }
}

class MessageList extends StatelessWidget {
  const MessageList({
    super.key,
    required this.savedMessages,
    required this.title,
  });

  final List<ChatMessage> savedMessages;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: chatScreenColor,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: chatScreenColor,
        surfaceTintColor: chatScreenColor,
        titleSpacing: 0,
      ),
      body: ListView.builder(
        itemCount: savedMessages.length,
        itemBuilder: (context, index) {
          final message = savedMessages[index];
          return BuildMessageItem(
            message: message,
            index: index,
          );
        },
      ),
    );
  }
}
