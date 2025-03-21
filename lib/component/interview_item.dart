import 'package:flutter/material.dart';
import 'package:flutter_interview/color/colors.dart';
import 'package:intl/intl.dart';

class InterviewItem extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool buttonEnable;
  final String? createdAt;

  const InterviewItem({
    super.key,
    required this.title,
    required this.onPressed,
    required this.buttonEnable,
    this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    // saveTime = DateFormat('yy.MM.dd').format(DateTime.now());
    final DateTime datetime = DateTime.parse(createdAt ?? '0000-01-01');
    final String displayTime = DateFormat('yy.MM.dd').format(datetime);

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
                title,
                style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              buttonEnable
                  ? Container(
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(color: buttonColor, blurRadius: 1)
                        ],
                        borderRadius: BorderRadius.circular(8.0),
                        color: primaryColor,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "면접 진행",
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                      ),
                    )
                  : Text(
                      displayTime,
                      style: const TextStyle(
                          fontSize: 13.0, color: Colors.black54),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
