import 'package:flutter/material.dart';
import 'package:the_notebook/features/diary/domain/diary_image.dart';
import 'package:the_notebook/features/diary/domain/tag.dart';
import 'package:the_notebook/features/diary/domain/task.dart';

class Diary {
  final int? id;
  final DateTime date;
  final TimeOfDay time;
  final String title;
  final List<Tag>? tags;
  final String? content;
  final List<DiaryImage>? images;
  final List<Task>? tasks;
  final int notebookId;
  final DateTime? createdAt;

  Diary({
    this.id,
    required this.date,
    this.content,
    required this.title,
    this.tags,
    required this.time,
    required this.notebookId,
    this.images,
    this.createdAt,
    List<Task>? tasks,
  }) : tasks = tasks ?? <Task>[];
}
