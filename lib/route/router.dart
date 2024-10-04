import 'package:flutter/cupertino.dart';
import 'package:flutter_interview/providers/chat_provider.dart';
import 'package:flutter_interview/providers/scroll_controller_provider.dart';
import 'package:flutter_interview/screens/archive_screen.dart';
import 'package:flutter_interview/screens/chat_screen.dart';
import 'package:flutter_interview/screens/home_screen.dart';
import 'package:flutter_interview/screens/main_screen.dart';
import 'package:flutter_interview/screens/learning_screen.dart';
import 'package:flutter_interview/screens/pick_subject_screen.dart';
import 'package:flutter_interview/screens/profile_screen.dart';
import 'package:flutter_interview/screens/question_count_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// OpenAIService _openAIService = OpenAIService();
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
          pageBuilder: (context, state) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<ChatProvider>().setIsLearning(false);
            });
            // NoTransitionPage => 전환 애니메이션 제거
            // 화면 전환시 깜빡이는 문제 해결하기 위해서
            // 페이지 전환 애니메이션 주거나 제거 해야함.
            return const NoTransitionPage(child: HomeScreen());
          },
        ),
        GoRoute(
          path: '/learning',
          pageBuilder: (context, state) {
            final subject = state.extra != null
                ? state.extra.toString()
                : 'Unknown Subject';
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<ChatProvider>().setIsLearning(true);
            });
            return NoTransitionPage(child: LearningScreen(subject: subject));
          },
        ),
        GoRoute(
          path: '/archive',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: ArchiveScreen()),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ProfileScreen()),
        ),
      ],
    ),
    GoRoute(
      path: '/subject',
      builder: (context, state) {
        final subject =
            state.extra != null ? state.extra.toString() : 'Unknown Subject';
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   context.read<ScrollControllerProvider>().setScrollController();
        // });

        return PickSubjectScreen(subject: subject);
      },
    ),
    GoRoute(
      path: '/question',
      builder: (context, state) {
        final subject =
            state.extra != null ? state.extra.toString() : 'Unknown Subject';
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   // context.read<ScrollControllerProvider>().setScrollController();
        // });

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
