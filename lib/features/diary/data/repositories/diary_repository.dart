import 'package:drift/drift.dart';
import 'package:the_notebook/core/database/app_database.dart'
    show AppDatabase, DiariesCompanion, TasksCompanion;
import 'package:the_notebook/features/diary/domain/task.dart';
import 'package:the_notebook/features/diary/domain/diary.dart';
import 'package:the_notebook/features/diary/data/seed_data.dart';

class DiaryRepository {
  final AppDatabase database;

  DiaryRepository(this.database);

  Future<List<Diary>> getDiaryEntries() async {
    final diaries = await database.select(database.diaries).get();
    final List<Diary> result = [];

    for (var diary in diaries) {
      final tasks = await (database.select(
        database.tasks,
      )..where((t) => t.diaryId.equals(diary.id))).get();

      final List<Task> taskList = [];
      for (var task in tasks) {
        if (task.parentTaskId == null) {
          final subtasks = await (database.select(
            database.tasks,
          )..where((t) => t.parentTaskId.equals(task.id))).get();

          taskList.add(
            Task(
              id: task.id,
              title: task.title,
              isDone: task.isDone,
              diaryId: task.diaryId,
              parentTaskId: task.parentTaskId,
              subtasks: subtasks
                  .map(
                    (s) => Task(
                      id: s.id,
                      title: s.title,
                      isDone: s.isDone,
                      diaryId: s.diaryId,
                      parentTaskId: s.parentTaskId,
                    ),
                  )
                  .toList(),
            ),
          );
        }
      }

      result.add(
        Diary(
          id: diary.id,
          date: diary.date,
          content: diary.content,
          imageUrl: diary.imageUrl,
          tasks: taskList,
        ),
      );
    }

    result.sort((a, b) => a.date.compareTo(b.date));
    return result;
  }

  Future<void> seedIfEmpty() async {
    final count = await database.select(database.diaries).get();
    if (count.isNotEmpty) return;

    for (var entry in sampleDiaries) {
      await insertDiary(entry);
    }
  }

  Future<int> insertDiary(Diary diary) async {
    final diaryId = await database
        .into(database.diaries)
        .insert(
          DiariesCompanion.insert(
            date: diary.date,
            content: diary.content,
            imageUrl: Value(diary.imageUrl),
          ),
        );

    if (diary.tasks != null) {
      for (var task in diary.tasks!) {
        final taskId = await database
            .into(database.tasks)
            .insert(
              TasksCompanion.insert(
                title: Value(task.title),
                isDone: Value(task.isDone ?? false),
                diaryId: Value(diaryId),
              ),
            );

        if (task.subtasks != null) {
          for (var subtask in task.subtasks!) {
            await database
                .into(database.tasks)
                .insert(
                  TasksCompanion.insert(
                    title: Value(subtask.title),
                    isDone: Value(subtask.isDone ?? false),
                    diaryId: Value(diaryId),
                    parentTaskId: Value(taskId),
                  ),
                );
          }
        }
      }
    }

    return diaryId;
  }
}
