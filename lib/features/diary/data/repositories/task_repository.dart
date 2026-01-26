import 'package:drift/drift.dart';
import 'package:the_notebook/core/models/task.dart';
import 'package:the_notebook/core/database/database.dart';

class TaskRepository {
  final AppDatabase _db = AppDatabase();

  TaskRepository();

  Future<int> insertTask(TaskModel task, int diaryId) async {
    return await _db.into(_db.tasks).insert(TasksCompanion.insert(
        title: task.title,
        isCompleted: Value(task.isCompleted),
        diaryId: Value(diaryId)));
  }

  Future<List<TaskModel>> getTasksForDiary(int diaryId) async {
    final dbTasks = await (_db.select(_db.tasks)
          ..where((t) => t.diaryId.equals(diaryId)))
        .get();
    final parentTasks = dbTasks.where((t) => t.parentTaskId == null).toList();
    final result = <TaskModel>[];

    for (var task in parentTasks) {
      final subtasks = await getSubtasksForTask(task.id);
      result.add(
        TaskModel(
          id: task.id,
          title: task.title,
          isCompleted: task.isCompleted,
          diaryId: task.diaryId,
          subtasks: subtasks.isEmpty ? null : subtasks,
        ),
      );
    }

    return result;
  }

  Future<List<TaskModel>> getSubtasksForTask(int parentTaskId) async {
    final dbSubtasks = await (_db.select(_db.tasks)
          ..where((t) => t.parentTaskId.equals(parentTaskId)))
        .get();
    return dbSubtasks
        .map(
          (st) => TaskModel(
            id: st.id,
            title: st.title,
            isCompleted: st.isCompleted,
            diaryId: st.diaryId,
            parentTaskId: st.parentTaskId,
          ),
        )
        .toList();
  }

  Future<bool> updateTask(TaskModel task) async {
    final rowsAffected = await (_db.update(_db.tasks)
          ..where((t) => t.id.equals(task.id!)))
        .write(TasksCompanion(
      title: Value(task.title),
      isCompleted: Value(task.isCompleted),
    ));
    return rowsAffected > 0;
  }

  Future<bool> deleteTask(int taskId) async {
    // Delete the task and all its subtasks
    await (_db.delete(_db.tasks)..where((t) => t.parentTaskId.equals(taskId)))
        .go();
    final rowsAffected =
        await (_db.delete(_db.tasks)..where((t) => t.id.equals(taskId))).go();
    return rowsAffected > 0;
  }

  Future<void> deleteTasksByDiaryId(int diaryId) async {
    await (_db.delete(_db.tasks)..where((tbl) => tbl.diaryId.equals(diaryId)))
        .go();
  }

  void dispose() {
    _db.close();
  }
}
