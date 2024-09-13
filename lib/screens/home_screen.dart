import 'package:flutter/material.dart';
import 'package:flutter_interview/component/banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        TopBanner(),
        InterviewBanner(),
      ],
    );
  }
}
