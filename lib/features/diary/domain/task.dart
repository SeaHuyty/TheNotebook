class Task {
  final int? id;
  final String? title;
  final bool? isDone;
  final List<Task>? subtasks;
  final int? diaryId;
  final int? parentTaskId;

  Task({
    this.id,
    this.title,
    this.isDone,
    this.subtasks,
    this.diaryId,
    this.parentTaskId,
  });
}
