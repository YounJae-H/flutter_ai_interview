import 'package:flutter/material.dart';
import 'package:flutter_interview/providers/chat_provider.dart';
import 'package:flutter_interview/widgets/message_item.dart';
import 'package:provider/provider.dart';

class BuildMessageList extends StatelessWidget {
  final ScrollController scrollController;
  final VoidCallback scrollToBottom;
  const BuildMessageList(
      {super.key,
      required this.scrollController,
      required this.scrollToBottom});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());

        return ListView.builder(
          controller: scrollController,
          itemCount: chatProvider.messages.length,
          itemBuilder: (context, index) {
            final message = chatProvider.messages[index];
            if (index == 0 && message.isUser) {
              return Container();
            }

            return BuildMessageItem(
              message: message,
              index: index,
            );
          },
        );
      },
    );
  }
}
