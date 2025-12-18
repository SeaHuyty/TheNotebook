import 'package:minimal_diary/features/diary/domain/task.dart';

class Diary {
  final DateTime date;
  final String content;
  final String imageUrl;
  final List<Task>? tasks;

  const Diary({
    required this.date,
    required this.content,
    required this.imageUrl,
    this.tasks
  });
}
