import 'package:flutter/material.dart';
import 'package:the_notebook/features/diary/domain/diary.dart';

class EditDiaryPage extends StatelessWidget {
  final Diary diary;

  const EditDiaryPage({super.key, required this.diary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [TextButton(onPressed: () {}, child: Text('Done'))],
      ),
      body: Text('Hello World'),
    );
  }
}