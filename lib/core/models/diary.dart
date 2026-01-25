import 'package:flutter/material.dart';
import 'package:the_notebook/core/models/diary_image.dart';
import 'package:the_notebook/core/models/tag.dart';
import 'package:the_notebook/core/models/task.dart';

class DiaryModel {
  final int? id;
  final DateTime date;
  final TimeOfDay time;
  final String title;
  final List<TagModel>? tags;
  final String? content;
  final List<DiaryImageModel>? images;
  final List<TaskModel>? tasks;
  final int notebookId;
  final DateTime? createdAt;

  DiaryModel({
    this.id,
    required this.date,
    this.content,
    required this.title,
    this.tags,
    required this.time,
    required this.notebookId,
    this.images,
    this.createdAt,
    List<TaskModel>? tasks,
  }) : tasks = tasks ?? <TaskModel>[];
}
