import 'package:flutter/material.dart';
import 'package:flutter_interview/providers/chat_provider.dart';
import 'package:flutter_interview/providers/keyboard_provider.dart';
import 'package:flutter_interview/widgets/message_input.dart';
import 'package:flutter_interview/widgets/message_list.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _isSendButtonEnabled =
      ValueNotifier(true); // boolean 값을 감시

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    // 텍스트 필드의 내용이 변경될 때마다 Listener가 실행
    _controller.addListener(() {
      // 텍스트 필드 내의 내용이 있는지 확인. 비어 있으면 true 반환
      _isSendButtonEnabled.value = _controller.text.isEmpty;
      _updateKeyboardHeight();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _isSendButtonEnabled.dispose();
    super.dispose();
  }

  void _updateKeyboardHeight() {
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    Provider.of<KeyboardProvider>(context, listen: false)
        .updateKeyboardHeight(keyboardHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFBACEE0),
      appBar: AppBar(
        title: Text("플접관"),
        backgroundColor: Color(0xFFBACEE0),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // 화면을 탭하면 키보드를 닫음
        child: SafeArea(
          child: Consumer<KeyboardProvider>(
            builder: (BuildContext context, value, Widget? child) {
              return Column(
                children: [
                  Expanded(
                      child: BuildMessageList(
                    scrollController: _scrollController,
                    scrollToBottom: _scrollToBottom,
                  )),
                  BuildMessageInput(
                    controller: _controller,
                    isSendButtonEnabled: _isSendButtonEnabled,
                    // onSubmitted: _handleSubmitted,  //엔터
                    onPressed: _handleSendPressed,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // void _handleSubmitted(String text) {
  //   if (text.isNotEmpty) {
  //     Provider.of<ChatProvider>(context, listen: false).sendMessage(text);
  //     _controller.clear();
  //   }
  // }

  void _handleSendPressed() {
    if (_controller.text.isNotEmpty) {
      Provider.of<ChatProvider>(context, listen: false)
          .sendMessage(_controller.text);
      _controller.clear();
      _isSendButtonEnabled.value = true;
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }
}
