import 'package:the_notebook/features/diary/domain/diary_image.dart';
import 'package:the_notebook/features/diary/domain/task.dart';

class Diary {
  final int? id;
  final DateTime date;
  final String content;
  final DiaryImage? image;
  final List<Task>? tasks;

  Diary({
    this.id,
    required this.date,
    required this.content,
    this.image,
    List<Task>? tasks,
  }) : tasks = tasks ?? <Task>[];
}
