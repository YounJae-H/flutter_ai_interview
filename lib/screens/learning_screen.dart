import 'package:flutter/material.dart';
import 'package:flutter_interview/component/home_banner.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({super.key, required String subject});

  @override
  Widget build(BuildContext context) {
    return Column(children: [TopBanner()]);
  }
}
