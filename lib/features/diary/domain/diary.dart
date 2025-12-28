import 'package:the_notebook/features/diary/domain/task.dart';

class Diary {
  final int? id;
  final DateTime date;
  final String content;
  final String? imageUrl;
  final List<Task>? tasks;

  Diary({
    this.id,
    required this.date,
    required this.content,
    this.imageUrl,
    List<Task>? tasks,
  }) : tasks = tasks ?? <Task>[];
}
