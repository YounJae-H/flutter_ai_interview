import 'package:flutter/material.dart';
import 'package:flutter_interview/providers/chat_provider.dart';
import 'package:provider/provider.dart';

class ArchiveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    return ListView.builder(
      itemCount: chatProvider.saveMessages.length,
      itemBuilder: (context, index) {
        final savedMessages = chatProvider.getSavedMessages(index);

        return ExpansionTile(
          title: Row(
            children: [
              Text('대화 기록 $index'),
              TextButton(
                  onPressed: () {
                    chatProvider.deleteSavedMessages(index);
                  },
                  child: Text('삭제'))
            ],
          ),
          children: savedMessages.map((message) {
            return ListTile(
              title: Text(message.message),
              subtitle: Text(message.isUser ? 'User' : 'AI'),
            );
          }).toList(),
        );
      },
    );
  }
}
