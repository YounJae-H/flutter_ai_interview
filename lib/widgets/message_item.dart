import 'package:flutter/material.dart';
import 'package:flutter_interview/models/chat_message.dart';
import 'package:flutter_interview/widgets/message_content.dart';

class BuildMessageItem extends StatelessWidget {
  final ChatMessage message;
  const BuildMessageItem({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Align(
        alignment:
            message.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: BuildMessageContent(
          message: message.message,
          isUser: message.isUser,
        ),
      ),
    );
  }
}
