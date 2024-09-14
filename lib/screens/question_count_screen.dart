import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_interview/providers/chat_provider.dart';
import 'package:flutter_interview/providers/scroll_controller_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class QuestionCountScreen extends StatelessWidget {
  final String subject;
  const QuestionCountScreen({
    super.key,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    final scrollController =
        context.watch<ScrollControllerProvider>().questionScrollController;
    // final chatProvider = context.read<ChatProvider>();
    // final _difficulty = chatProvider.difficulty;
    // String _selectedDifficulty = chatProvider.selectedDifficulty; 난이도 관련
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(subject),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                child: Text(
                  "몇 개의 면접 질문을\n원하시나요?",
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                    scrollController: scrollController,
                    itemExtent: 40.0,
                    onSelectedItemChanged: (index) {
                      context.read<ChatProvider>().updateQuestionCount(
                          scrollController.selectedItem + 2);
                    },
                    children: List<Widget>.generate(
                        9,
                        (int index) => Center(
                              child: Text(
                                '${index + 2}',
                                style: const TextStyle(fontSize: 28.0),
                              ),
                            ))),
              ),
              // 난이도 설정하는 위젯 (적용은 안할 예정)
              // DropdownButton<String>(
              //   value: context.watch<ChatProvider>().selectedDifficulty,
              //   items: context.read<ChatProvider>().difficulty.map((value) {
              //     return DropdownMenuItem(value: value, child: Text(value));
              //   }).toList(),
              //   onChanged: (String? newValue) {
              //     print(newValue);
              //     context
              //         .read<ChatProvider>()
              //         .updateQuestionDifficulty(newValue!);
              //   },
              // ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                // AspectRatio를 사용하여 버튼을 일정 비율의 크기로 고정
                child: AspectRatio(
                  aspectRatio: 6 / 1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0))),
                    onPressed: () {
                      context.push('/chat', extra: subject);
                      context.read<ChatProvider>().setSubject(subject);
                      context.read<ChatProvider>().sendMessage(
                          '면접 질문 ${context.read<ChatProvider>().questionCount}개');

                      // context.read<ChatProvider>().sendMessage(
                      //     '면접 질문 ${context.read<ChatProvider>().questionCount}개 / 난이도${context.read<ChatProvider>().selectedDifficulty}로 해주세요. 난이도도 언급하세요');
                    },
                    child: const Text(
                      "시작하기",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
