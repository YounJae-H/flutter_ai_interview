import 'package:flutter/material.dart';
import 'package:flutter_interview/providers/chat_provider.dart';
import 'package:flutter_interview/providers/scroll_controller_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              '알림',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const Text(
              '면접을 종료하시겠습니까?',
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w700),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                left: 20.0,
                right: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () => context.pop(),
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 55.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            backgroundColor: Colors.blueGrey),
                        child: const Text(
                          "취소",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        )),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          context.read<ChatProvider>().endInterview();
                          context
                              .read<ScrollControllerProvider>()
                              .setScrollController();
                          context.go('/home');
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 55.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                            backgroundColor: Colors.blue),
                        child: const Text(
                          "종료",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
