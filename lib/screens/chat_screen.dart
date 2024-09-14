import 'package:flutter/material.dart';
import 'package:flutter_interview/providers/chat_provider.dart';
import 'package:flutter_interview/providers/keyboard_provider.dart';
import 'package:flutter_interview/component/custom_dialog.dart';
import 'package:flutter_interview/widgets/answer_check_button.dart';
import 'package:flutter_interview/widgets/message_input.dart';
import 'package:flutter_interview/widgets/message_list.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String subject;

  const ChatScreen({super.key, required this.subject});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _isSendButtonEnabled =
      ValueNotifier(true); // boolean 값을 감시

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    // 텍스트 필드의 내용이 변경될 때마다 Listener가 실행
    _textEditingController.addListener(() {
      // 텍스트 필드 내의 내용이 있는지 확인. 비어 있으면 true 반환
      _isSendButtonEnabled.value = _textEditingController.text.isEmpty;
      _updateKeyboardHeight();
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
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
    final isLearning = context.read<ChatProvider>().isLearning;
    // final isEnded = context.read<ChatProvider>().isEnded;

    return PopScope(
      canPop: false, // 뒤로가기 비활성화
      onPopInvoked: (bool didPop) {
        if (isTyping == didPop) {
          showDialog(
              context: context,
              builder: (_) {
                return CustomDialog();
              });
        }
        return;
      },
      child: Scaffold(
        backgroundColor: Color(0xFFBACEE0),
        appBar: AppBar(
          title: Text(widget.subject),
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
                      child: Stack(
                        children: [
                          isFirstLoading // ai의 첫 응답이 올때까지 대기
                              ? const Center(child: CircularProgressIndicator())
                              : BuildMessageList(
                                  scrollController: _scrollController,
                                  scrollToBottom: _scrollToBottom,
                                ),
                        ],
                      ),
                    ),
                    !isLearning
                        ? BuildMessageInput(
                            controller: _textEditingController,
                            isSendButtonEnabled: _isSendButtonEnabled,
                            // onSubmitted: _handleSubmitted,  //엔터
                            onPressed: _handleSendPressed,
                          )
                        : AnswerCheckButton(onPressed: _answerSendPressed),
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
    final chatProvider = context.read<ChatProvider>();

    if (_textEditingController.text.isNotEmpty) {
      chatProvider.sendMessage(_textEditingController.text);
      _textEditingController.clear();
      _isSendButtonEnabled.value = true;
    }
    return;
  }

  void _answerSendPressed() {
    final chatProvider = context.read<ChatProvider>();
    final isLearning = context.read<ChatProvider>().isLearning;
    final answerRespone = context.read<ChatProvider>().answerRespone;

    if (isLearning) chatProvider.sendMessage(answerRespone);

    return;
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }
}
