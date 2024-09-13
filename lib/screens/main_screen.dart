import 'package:flutter/material.dart';
import 'package:flutter_interview/component/custom_bottom_navigation.dart';
import 'package:flutter_interview/providers/bottom_navigation_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  final child;
  const MainScreen({super.key, this.child});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<String> _routes = ['/home', '/learning', '/archive', '/profile'];
  @override
  Widget build(BuildContext context) {
    final int currentIndex =
        context.watch<BottomNavigationProvider>().currentIndex;
    return Scaffold(
      backgroundColor: Color(0xFFBACEE0),
      appBar: AppBar(
        title: const Text(
          "MOAI",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFBACEE0),
      ),
      body: widget.child,
      bottomNavigationBar: CutomBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: _onItemTap,
      ),
    );
  }

  void _onItemTap(int index) {
    context.read<BottomNavigationProvider>().updateIndex(index);
    context.go(_routes[index]);
  }
}