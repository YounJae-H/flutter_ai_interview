import 'package:flutter/material.dart';

class BuildMessageContent extends StatelessWidget {
  final String message;
  final bool isUser;

  const BuildMessageContent({
    super.key,
    required this.message,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    final lines = message.split('\n').where((line) => line.trim().isNotEmpty);
    double screenWidth = MediaQuery.of(context).size.width * 0.6;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: !isUser
          ? lines.map((line) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Container(
                  constraints: BoxConstraints(maxWidth: screenWidth),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: line.contains('정답입니다') ? Colors.red : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    line,
                    style: line.contains('정답입니다')
                        ? TextStyle(color: Colors.white)
                        : TextStyle(color: Colors.black),
                  ),
                ),
              );
            }).toList()
          : [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Container(
                  constraints: BoxConstraints(maxWidth: screenWidth),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    message,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
    );
  }
}
