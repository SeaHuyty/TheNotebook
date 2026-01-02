import 'package:drift/drift.dart';
import 'package:the_notebook/features/diary/domain/task.dart' as domain;
import 'package:the_notebook/core/database/database.dart';

class TaskRepository {
  final AppDatabase _db = AppDatabase();

  TaskRepository();

  Future<int> insertTask(domain.Task task, int diaryId) async {
    return await _db.into(_db.tasks).insert(TasksCompanion.insert(
      title: task.title ?? '',
      isDone: Value(task.isDone ?? false),
      diaryId: Value(diaryId)
    ));
  }

  Future<List<domain.Task>> getTasksForDiary(int diaryId) async {
    final dbTasks = await (_db.select(_db.tasks)
          ..where((t) => t.diaryId.equals(diaryId)))
        .get();
    final parentTasks = dbTasks.where((t) => t.parentTaskId == null).toList();
    final result = <domain.Task>[];

    for (var task in parentTasks) {
      final subtasks = await getSubtasksForTask(task.id);
      result.add(
        domain.Task(
          id: task.id,
          title: task.title,
          isDone: task.isDone,
          diaryId: task.diaryId,
          subtasks: subtasks.isEmpty ? null : subtasks,
        ),
      );
    }

    return result;
  }

  Future<List<domain.Task>> getSubtasksForTask(int parentTaskId) async {
    final dbSubtasks = await (_db.select(_db.tasks)
          ..where((t) => t.parentTaskId.equals(parentTaskId)))
        .get();
    return dbSubtasks
        .map(
          (st) => domain.Task(
            id: st.id,
            title: st.title,
            isDone: st.isDone,
            diaryId: st.diaryId,
            parentTaskId: st.parentTaskId,
          ),
        )
        .toList();
  }

  Future<void> deleteTasksByDiaryId(int diaryId) async {
    await (_db.delete(_db.tasks)
          ..where((tbl) => tbl.diaryId.equals(diaryId)))
        .go();
  }

  void dispose() {
    _db.close();
  }
}
