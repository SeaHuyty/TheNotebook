import 'package:flutter/material.dart';
import 'package:the_notebook/features/diary/domain/diary_image.dart';
import 'package:the_notebook/features/diary/domain/task.dart';

class Diary {
  final int? id;
  final DateTime date;
  final TimeOfDay time;
  final String title;
  final String? tag;
  final String? content;
  final DiaryImage? image;
  final List<Task>? tasks;
  final int notebookId;

  Diary({
    this.id,
    required this.date,
    this.content,
    required this.title,
    this.tag,
    required this.time,
    required this.notebookId,
    this.image,
    List<Task>? tasks,
  }) : tasks = tasks ?? <Task>[];
}
