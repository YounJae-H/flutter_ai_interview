import 'package:flutter/material.dart';
import 'package:flutter_interview/providers/scroll_controller_provider.dart';
import 'package:flutter_interview/screens/chat_screen.dart';
import 'package:flutter_interview/screens/home_screen.dart';
import 'package:flutter_interview/screens/question_count_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/question',
      builder: (context, state) {
        // extra 값이 null인지 확인하고 String으로 안전하게 변환
        final subject =
            state.extra != null ? state.extra.toString() : 'Unknown Subject';
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // 페이지 빌드 후 상태를 변경
          context.read<ScrollControllerProvider>().setScrollController();
        });

        return QuestionCountScreen(
          subject: subject,
        );
      },
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) {
        // extra 값이 null인지 확인하고 String으로 안전하게 변환
        final subject =
            state.extra != null ? state.extra.toString() : 'Unknown Subject';

        return ChatScreen(
          subject: subject,
        );
      },
    ),
  ],
);
