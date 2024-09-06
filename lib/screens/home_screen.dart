import 'package:flutter/material.dart';
import 'package:flutter_interview/component/bottom_navigation.dart';
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
                context.push('/question');
              },
              child: Text("Flutter/Dart"))
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
