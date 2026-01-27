import 'package:the_notebook/core/database/database.dart';

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

  factory TaskModel.fromDrift(Task task, List<TaskModel> subtasks) {
    return TaskModel(
      id: task.id,
      title: task.title, 
      isCompleted: task.isCompleted,
      diaryId: task.diaryId,
      parentTaskId: task.parentTaskId,
      subtasks: subtasks.isEmpty ? null : subtasks
    );
  }
}
