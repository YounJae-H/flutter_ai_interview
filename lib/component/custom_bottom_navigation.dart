import 'package:flutter/material.dart';
import 'package:flutter_interview/color/colors.dart';

class CutomBottomNavigationBar extends StatelessWidget {
  final ValueChanged<int>? onTap;
  final int currentIndex;
  const CutomBottomNavigationBar(
      {super.key, required this.onTap, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        // highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        selectedLabelStyle: const TextStyle(fontSize: 13),
        unselectedLabelStyle: const TextStyle(fontSize: 13),
        onTap: onTap,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        backgroundColor: primaryColor,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: '학습'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: '보관함'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '내 정보'),
        ],
      ),
    );
  }
}
