class TaskModel {
  final int? id;
  final String title;
  final bool isCompleted;
  final int? diaryId;
  final int? parentTaskId;
  final List<TaskModel>? subtasks;

  TaskModel({
    this.id,
    required this.title,
    required this.isCompleted,
    this.diaryId,
    this.parentTaskId,
    this.subtasks = const [],
  });
}
