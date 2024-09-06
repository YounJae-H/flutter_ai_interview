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
    final isFirstLoading = context.watch<ChatProvider>().isFirstMessage;
    final isTyping = context.read<ChatProvider>().isTyping;
    return PopScope(
      canPop: isTyping ? false : true, // ai 응답이 오는 중이라면 뒤로가기 비활성화
      onPopInvoked: (bool didPop) {
        // print(didPop);
        if (didPop == true) context.read<ChatProvider>().endInterview();
        return;
      },
      child: Scaffold(
        backgroundColor: Color(0xFFBACEE0),
        appBar: AppBar(
          title: const Text("Flutter/Dart"),
          backgroundColor: Color(0xFFBACEE0),
          surfaceTintColor: Color(0xFFBACEE0),
          titleSpacing: 0,
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), // 화면을 탭하면 키보드를 닫음
          child: SafeArea(
            // 텍스트 필드 높이가 변할 때 값을 전달하기 위함 / 높이 만큼 패딩을 추가하여 화면 가림을 방지
            child: Consumer<KeyboardProvider>(
              builder: (BuildContext context, value, Widget? child) {
                return Column(
                  children: [
                    Expanded(
                        child: isFirstLoading // ai의 첫 응답이 올때까지 대기
                            ? const Center(child: CircularProgressIndicator())
                            : BuildMessageList(
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
      context.read<ChatProvider>().sendMessage(_controller.text);
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
