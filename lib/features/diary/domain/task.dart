class Task {
  final int? id;
  final String title;
  final bool isCompleted;
  final int? diaryId;
  final int? parentTaskId;
  final List<Task>? subtasks;

  Task({
    this.id,
    required this.title,
    required this.isCompleted,
    this.diaryId,
    this.parentTaskId,
    this.subtasks = const [],
  });
}
