import 'package:flutter/material.dart';
import 'package:flutter_interview/component/interview_item.dart';
import 'package:go_router/go_router.dart';

class MainBanner extends StatelessWidget {
  const MainBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              "AI 면접",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          InterviewItem(
            title: 'Flutter/Dart',
            onPressed: () => context.push('/question', extra: 'Flutter/Dart'),
            buttonEnable: true,
          ),
          InterviewItem(
            title: '주제 설정',
            onPressed: () => context.push('/subject', extra: '주제 설정'),
            buttonEnable: true,
          ),
        ],
      ),
    );
  }
}

class TopBanner extends StatelessWidget {
  const TopBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.white,
      child: TextButton(
        style: TextButton.styleFrom(
            overlayColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0))),
        onPressed: () {
          // context.read<ChatProvider>().setIsLearning(true);
          context.push(
              '/learning'); // router에서 learning페이지로 이동하면 chatProvider의 isLearning를 true로 바꾸도록 설정했음.
          context.push('/subject', extra: 'AI 학습');
        },
        child: const SizedBox(
          height: 80,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '안녕하세요!\nAI 학습을 진행해보세요!',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Icon(
                Icons.edit,
                size: 45.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
