import 'package:flutter/material.dart';
import 'package:flutter_interview/providers/chat_provider.dart';
import 'package:provider/provider.dart';

class BuildMessageContent extends StatelessWidget {
  final String message;
  final bool isUser;
  final int index;

  const BuildMessageContent({
    super.key,
    required this.message,
    required this.isUser,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final lines = message.split('\n').where((line) => line.trim().isNotEmpty);
    final chatProvider = context.read<ChatProvider>();
    final isLoading = chatProvider.isLoading;
    final isLastMessage =
        index == chatProvider.messages.length - 1; // 유저 마지막 메시지 확인
    double screenWidth = MediaQuery.of(context).size.width * 0.6;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: isLoading && isLastMessage
          ? [
              _buildUserMessage(message: message, screenWidth: screenWidth),
              _buildLoadingIndicator(),
            ]
          : !isUser
              ? _buildBotMessage(lines: lines, screenWidth: screenWidth)
              : [_buildUserMessage(message: message, screenWidth: screenWidth)],
    );
  }

  Widget _buildUserMessage(
      {required String message, required double screenWidth}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Container(
        constraints: BoxConstraints(maxWidth: screenWidth),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const SizedBox(
      height: 16.0,
      width: 16.0,
      child: CircularProgressIndicator(
        strokeWidth: 1.6,
      ),
    );
  }

  List<Widget> _buildBotMessage(
      {required Iterable<String> lines, required double screenWidth}) {
    return lines.map((line) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: Container(
          constraints: BoxConstraints(maxWidth: screenWidth),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: line.contains('정답입니다！') ? Colors.red : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            line,
            style: line.contains('정답입니다！')
                ? TextStyle(color: Colors.white)
                : TextStyle(color: Colors.black),
          ),
        ),
      );
    }).toList();
  }
}
