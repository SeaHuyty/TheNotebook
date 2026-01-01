import 'package:drift/drift.dart';
import 'package:the_notebook/features/diary/domain/diary.dart' as domain;
import 'package:the_notebook/features/diary/data/seed/seed_data.dart';
import 'package:the_notebook/core/database/database.dart';
import 'package:the_notebook/features/diary/data/repositories/task_repository.dart';
import 'package:the_notebook/features/diary/data/repositories/diary_image_repository.dart';

class DiaryRepository {
  final AppDatabase _db = AppDatabase();
  final TaskRepository _taskRepo = TaskRepository();
  final DiaryImageRepository _imageRepo = DiaryImageRepository();

  DiaryRepository();

  Future<List<domain.Diary>> getDiaryEntries() async {
    final diaries = await _db.select(_db.diaries).get();
    final result = <domain.Diary>[];

    for (var diary in diaries) {
      final tasks = await _taskRepo.getTasksForDiary(diary.id);
      final image = await _imageRepo.getImageByDiaryId(diary.id);
      result.add(
        domain.Diary(
          id: diary.id,
          date: diary.date,
          content: diary.content,
          image: image,
          tasks: tasks,
        ),
      );
    }

    result.sort((a, b) => a.date.compareTo(b.date));
    return result;
  }

  Future<void> seedIfEmpty() async {
    final existing = await _db.select(_db.diaries).get();
    if (existing.isNotEmpty) return;

    for (var entry in sampleDiaries) {
      await insertDiary(entry);
    }
  }

  Future<int> insertDiary(domain.Diary diary) async {
    final diaryId = await _db.into(_db.diaries).insert(
          DiariesCompanion(
            date: Value(diary.date),
            content: Value(diary.content),
          ),
        );

    if (diary.tasks != null) {
      for (var task in diary.tasks!) {
        final taskId = await _taskRepo.insertTask(task, diaryId);

        if (task.subtasks != null) {
          for (var subtask in task.subtasks!) {
            await _db.into(_db.tasks).insert(
                  TasksCompanion(
                    title: Value(subtask.title ?? ''),
                    isDone: Value(subtask.isDone ?? false),
                    diaryId: Value(diaryId),
                    parentTaskId: Value(taskId),
                  ),
                );
          }
        }
      }
    }

    if (diary.image != null) {
      await _imageRepo.insertImage(diary.image!, diaryId);
    }

    return diaryId;
  }

  void dispose() {
    _db.close();
    _taskRepo.dispose();
    _imageRepo.dispose();
  }
}
