import 'package:flutter/material.dart';
import 'package:flutter_interview/providers/scroll_controller_provider.dart';
import 'package:flutter_interview/screens/archive_screen.dart';
import 'package:flutter_interview/screens/chat_screen.dart';
import 'package:flutter_interview/screens/home_screen.dart';
import 'package:flutter_interview/screens/main_screen.dart';
import 'package:flutter_interview/screens/learning_screen.dart';
import 'package:flutter_interview/screens/profile_screen.dart';
import 'package:flutter_interview/screens/question_count_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final router = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      // ShellRoute는 탭 네비게이션을 유지하는 데 적합
      builder: (context, state, child) {
        return MainScreen(child: child); // MainScreen에서 child를 받아서 표시
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: '/learning',
          builder: (context, state) {
            final subject = state.extra != null
                ? state.extra.toString()
                : 'Unknown Subject';
            return LearningScreen(subject: subject);
          },
        ),
        GoRoute(
          path: '/archive',
          builder: (context, state) => ArchiveScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/question',
      builder: (context, state) {
        final subject =
            state.extra != null ? state.extra.toString() : 'Unknown Subject';
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<ScrollControllerProvider>().setScrollController();
        });
        return QuestionCountScreen(subject: subject);
      },
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) {
        final subject =
            state.extra != null ? state.extra.toString() : 'Unknown Subject';
        return ChatScreen(subject: subject);
      },
    ),
  ],
);
