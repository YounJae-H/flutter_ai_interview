import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_interview/color/colors.dart';
import 'package:flutter_interview/providers/scroll_controller_provider.dart';
import 'package:flutter_interview/providers/pick_subject_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PickSubject extends StatelessWidget {
  final String subject;
  const PickSubject({
    super.key,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> pickSubject =
        context.watch<PickSubjectProvider>().subjectList;
    String _subject = context.watch<PickSubjectProvider>().pickSubject;
    final _scrollController =
        context.watch<ScrollControllerProvider>().pickSubjectScrollController;
    final _textEditingController =
        context.watch<PickSubjectProvider>().textEditingController;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(subject),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                child: Text(
                  "원하는 분야를\n선택해주세요.",
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                    scrollController: _scrollController,
                    itemExtent: 40.0,
                    onSelectedItemChanged: (index) {
                      _subject = pickSubject[index];
                      context.read<PickSubjectProvider>().setSubject(_subject);
                    },
                    children:
                        List<Widget>.generate(pickSubject.length, (int index) {
                      return Center(
                        child: Text(
                          pickSubject[index],
                          style: const TextStyle(fontSize: 28.0),
                        ),
                      );
                    })),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                color: Colors.grey[300],
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(color: Colors.blueGrey),
                      hintText: '직접 입력: ${_subject}',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                // AspectRatio를 사용하여 버튼을 일정 비율의 크기로 고정
                child: AspectRatio(
                  aspectRatio: 6 / 1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0))),
                    onPressed: () {
                      context.push('/question',
                          extra: _textEditingController.text.isNotEmpty
                              ? _textEditingController.text
                              : _subject);
                      _textEditingController.clear();
                    },
                    child: const Text(
                      "선택",
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
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
