import 'package:flutter/material.dart';
import 'package:flutter_interview/component/interview_item.dart';
import 'package:go_router/go_router.dart';

class InterviewBanner extends StatelessWidget {
  const InterviewBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Column(
        children: [
          const Text(
            "AI 면접",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          InterviewItem(
            subject: 'Flutter/Dart',
            onPressed: () => context.push('/question', extra: 'Flutter/Dart'),
          ),
          InterviewItem(
            subject: '주제 설정',
            onPressed: () => context.push('/question', extra: '테스트페이지'),
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
      color: Colors.white,
      child: TextButton(
        style: TextButton.styleFrom(
            overlayColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0))),
        onPressed: () {},
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
