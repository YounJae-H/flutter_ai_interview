import 'package:flutter/material.dart';
import 'package:flutter_interview/color/colors.dart';
import 'package:flutter_interview/component/interview_item.dart';
import 'package:flutter_interview/models/chat_message.dart';
import 'package:flutter_interview/providers/chat_provider.dart';
import 'package:flutter_interview/widgets/message_item.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    return ListView.builder(
      itemCount: chatProvider.saveMessages.length,
      itemBuilder: (context, index) {
        final List<ChatMessage> savedMessages =
            chatProvider.getSavedMessages(index);
        final String title = '면접 기록 ${index + 1}';

        return Column(
          children: [
            Card(
                elevation: 5,
                color: Colors.white,
                child: InterviewItem(
                  title: title,
                  onPressed: () {
                    context.push('/save',
                        extra: [savedMessages, title] as List);
                  },
                  buttonEnable: false,
                ))
          ],
        );
      },
    );
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
