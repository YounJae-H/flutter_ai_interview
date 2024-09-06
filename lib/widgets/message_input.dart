import 'package:flutter/material.dart';
import 'package:flutter_interview/providers/chat_provider.dart';
import 'package:flutter_interview/providers/keyboard_provider.dart';
import 'package:provider/provider.dart';

class BuildMessageInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onPressed;
  final ValueNotifier<bool> isSendButtonEnabled;

  const BuildMessageInput({
    super.key,
    required this.controller,
    this.onSubmitted,
    required this.onPressed,
    required this.isSendButtonEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final isTyping = context.watch<ChatProvider>().isTyping;
    final isEnded = context.watch<ChatProvider>().isInterviewEnded;
    final containerHeight = MediaQuery.of(context).size.height / 15;
    final keyboardHeight =
        Provider.of<KeyboardProvider>(context).keyboardHeight;

    return SafeArea(
      child: Container(
        color: Colors.white,
        constraints: BoxConstraints(
            minHeight: containerHeight, maxHeight: double.infinity),
        child: Padding(
          padding: EdgeInsets.only(
            left: 8.0,
            right: 0.0,
            bottom: keyboardHeight / 1000, // 키보드 높이만큼 패딩 추가
          ),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.end, // IconButton을 항상 우측 하단에 두기 위함
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 180),
                    child: TextField(
                      controller: controller,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: null,
                      textInputAction: TextInputAction.newline,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                      ),
                      enabled: !isEnded, // 면접이 종료되면 텍스트 필드 비활성화
                      // onSubmitted: isTyping ? null : onSubmitted,
                      onSubmitted: null,
                    ),
                  ),
                ),
              ),

              // _isSendButtonEnabled의 값이 변경되면 UI 재구성
              ValueListenableBuilder<bool>(
                valueListenable: isSendButtonEnabled,
                builder: (BuildContext context, bool isEnabled, Widget? child) {
                  final isBoolean = isTyping || isEnabled;
                  return SizedBox(
                    height: containerHeight,
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
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
