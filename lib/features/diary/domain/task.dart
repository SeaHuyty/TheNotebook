
import 'package:isar/isar.dart';

part 'task.g.dart';

@embedded
class Task {
  final String? title;
  final bool isDone;
  final List<Task>? subtasks;

  Task({
    this.title,
    this.isDone = false,
    this.subtasks,
  });
}
