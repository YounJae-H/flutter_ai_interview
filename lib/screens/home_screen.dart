import 'package:flutter/material.dart';
import 'package:flutter_interview/component/custom_bottom_navigation.dart';
import 'package:flutter_interview/providers/bottom_navigation_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFBACEE0),
      appBar: AppBar(
        title: Text("MOAI"),
        backgroundColor: Color(0xFFBACEE0),
      ),
      body: Column(
        children: [
          Card(
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
          ),
          Card(
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
                  onPressed: () =>
                      context.push('/question', extra: 'Flutter/Dart'),
                ),
                InterviewItem(
                  subject: '주제 설정',
                  onPressed: () => context.push('/question', extra: '테스트페이지'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CutomBottomNavigationBar(
        currentIndex: context.watch<BottomNavigationProvider>().currentIndex,
        onTap: _onItemTap,
      ),
    );
  }

  void _onItemTap(int index) {
    context.read<BottomNavigationProvider>().updateIndex(index);
  }
}

class InterviewItem extends StatelessWidget {
  final String subject;
  final VoidCallback onPressed;

  const InterviewItem({
    super.key,
    required this.subject,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: SizedBox(
        height: 70.0,
        child: TextButton(
          style: TextButton.styleFrom(
              overlayColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0))),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subject,
                style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.blueGrey[100],
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "면접 진행",
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey),
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
