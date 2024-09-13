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
      elevation: 5,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            child: const Text(
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
          ),
          InterviewItem(
            title: '주제 설정',
            onPressed: () => context.push('/subject', extra: '주제 설정'),
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
