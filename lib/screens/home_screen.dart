import 'package:flutter/material.dart';
import 'package:flutter_interview/screens/question_count_screen.dart';

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
          title: Text("플접관"),
          backgroundColor: Color(0xFFBACEE0),
        ),
        body: Column(
          children: [
            Container(
              child: Text("시작 페이지"),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => QuestionCountScreen()));
                },
                child: Text("Flutter/Dart"))
          ],
        ));
  }
}
