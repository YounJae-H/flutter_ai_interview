import 'package:flutter/material.dart';

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