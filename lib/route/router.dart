import 'package:flutter/material.dart';
import 'package:flutter_interview/screens/chat_screen.dart';
import 'package:flutter_interview/screens/home_screen.dart';
import 'package:flutter_interview/screens/question_count_screen.dart';
import 'package:go_router/go_router.dart';

final FixedExtentScrollController fixedExtentScrollController =
    FixedExtentScrollController(initialItem: 4);

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/question',
      builder: (context, state) => QuestionCountScreen(
        fixedExtentScrollController: fixedExtentScrollController,
      ),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => ChatScreen(),
    ),
  ],
);
