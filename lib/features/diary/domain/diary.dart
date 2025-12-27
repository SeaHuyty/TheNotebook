import 'package:minimal_diary/features/diary/domain/task.dart';
import 'package:isar/isar.dart';

part 'diary.g.dart';

@collection
class Diary {
  Id id = Isar.autoIncrement;

  final DateTime date;
  final String content;
  final String? imageUrl;
  final List<Task>? tasks;

  Diary({
    required this.date,
    required this.content,
    this.imageUrl,
    List<Task>? tasks,
  }) : tasks = tasks ?? <Task>[];
}
