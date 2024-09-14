import 'package:flutter/material.dart';
import 'package:flutter_interview/color/colors.dart';
import 'package:flutter_interview/providers/chat_provider.dart';
import 'package:provider/provider.dart';

class AnswerCheckButton extends StatelessWidget {
  final VoidCallback onPressed;
  const AnswerCheckButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final containerHeight = MediaQuery.of(context).size.height;
    final isTyping = context.watch<ChatProvider>().isTyping;
    final isEnded = context.watch<ChatProvider>().isEnded;
    final isBoolean = isTyping || isEnded;

    return Container(
      color: primaryColor,
      height: containerHeight / 15,
      width: containerHeight,
      child: IconButton(
        icon: const Icon(Icons.send),
        iconSize: 35.0,
        color: Colors.grey,
        style: isBoolean
            ? null
            : IconButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.yellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
        onPressed: isBoolean ? () {} : onPressed,
      ),
    );
  }
}
