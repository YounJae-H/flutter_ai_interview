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
      future: getMessageCount(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // 로딩 중
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}')); // 오류 발생
        } else if (!snapshot.hasData || snapshot.data!['count'] == 0) {
          return const Center(child: Text('저장된 면접 기록이 없습니다.'));
        } else {
          final messageCount = snapshot.data!['count'];
          final userId = snapshot.data!['userId'];

          // 모든 메시지 데이터를 한 번에 로딩
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: chatProvider.getAllSavedMessages(userId, messageCount),
            builder: (context, allMessagesSnapshot) {
              if (allMessagesSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (allMessagesSnapshot.hasError) {
                return Center(
                    child: Text('Error: ${allMessagesSnapshot.error}'));
              } else if (!allMessagesSnapshot.hasData ||
                  allMessagesSnapshot.data!.isEmpty) {
                return const Center(child: Text('면접 기록이 저장되지 않았습니다.'));
              } else {
                final savedMessagesList = allMessagesSnapshot.data!;

                return ListView.builder(
                  itemCount: savedMessagesList.length,
                  itemBuilder: (context, index) {
                    final savedMessages = savedMessagesList[index]['messages'];
                    final savedTime = savedMessagesList[index]['time'];
                    final String title = '면접 기록 ${messageCount - index}';

                    return Column(
                      children: [
                        Card(
                          elevation: 5,
                          color: Colors.white,
                          child: InterviewItem(
                            title: title,
                            createdAt: savedTime,
                            onPressed: () {
                              context
                                  .push('/save', extra: [savedMessages, title]);
                            },
                            buttonEnable: false,
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            },
          );
        }
      },
    );
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
