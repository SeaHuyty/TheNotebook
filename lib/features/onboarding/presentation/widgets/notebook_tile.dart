import 'package:flutter/material.dart';
import 'package:the_notebook/features/onboarding/model/notebook.dart';

class NotebookTile extends StatelessWidget {
  final Notebook notebook;
  final VoidCallback openDiary;

  const NotebookTile(
      {super.key, required this.notebook, required this.openDiary});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(notebook.title),
      trailing: Icon(Icons.travel_explore),
      onTap: openDiary,
    );
  }
}
