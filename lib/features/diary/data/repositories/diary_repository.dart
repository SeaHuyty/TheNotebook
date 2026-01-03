import 'package:drift/drift.dart';
import 'package:the_notebook/features/diary/domain/diary.dart' as domain;
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
          notebookId: diary.notebookId,
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

  Future<int> insertDiary(domain.Diary diary) async {
    final diaryId = await _db.into(_db.diaries).insert(
          DiariesCompanion(
            notebookId: Value(diary.notebookId),
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
                    title: Value(subtask.title),
                    isCompleted: Value(subtask.isCompleted),
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

  Future<void> updateDiary(domain.Diary diary,
      {bool contentChanged = false,
      bool dateChanged = false,
      bool imageChanged = false}) async {
    if (contentChanged || dateChanged) {
      await (_db.update(_db.diaries)..where((d) => d.id.equals(diary.id!)))
          .write(DiariesCompanion(
        content: contentChanged ? Value(diary.content) : Value.absent(),
        date: dateChanged ? Value(diary.date) : Value.absent(),
      ));
    }

    if (imageChanged) {
      await _imageRepo.deleteImageByDiaryId(diary.id!);

      if (diary.image != null) {
        await _imageRepo.insertImage(diary.image!, diary.id!);
      }
    }
  }

  Future<domain.Diary?> getDiaryById(int diaryId) async {
    final tasks = await _taskRepo.getTasksForDiary(diaryId);
    final image = await _imageRepo.getImageByDiaryId(diaryId);

    final query = _db.select(_db.diaries)
      ..where((tbl) => tbl.id.equals(diaryId));

    final diary = await query.getSingleOrNull();
    if (diary == null) return null;

    return domain.Diary(
      id: diary.id,
      notebookId: diary.notebookId,
      date: diary.date,
      content: diary.content,
      image: image,
      tasks: tasks,
    );
  }

  Future<List<domain.Diary>> getDiaryEntriesByYear(int year) async {
    final startOfYear = DateTime(year, 1, 1);
    final endOfYear = DateTime(year, 12, 31, 23, 59, 59);

    final query = _db.select(_db.diaries)
      ..where((tbl) =>
          tbl.date.isBiggerOrEqualValue(startOfYear) &
          tbl.date.isSmallerOrEqualValue(endOfYear));

    final result = await query.get();
    final diaries = <domain.Diary>[];

    for (var diary in result) {
      final tasks = await _taskRepo.getTasksForDiary(diary.id);
      final image = await _imageRepo.getImageByDiaryId(diary.id);

      diaries.add(
        domain.Diary(
            id: diary.id,
            notebookId: diary.notebookId,
            date: diary.date,
            content: diary.content,
            image: image,
            tasks: tasks),
      );
    }

    diaries.sort((a, b) => a.date.compareTo(b.date));
    return diaries;
  }

  Future<List<int>> getAvailableYears() async {
    final query = _db.selectOnly(_db.diaries)..addColumns([_db.diaries.date]);

    final results = await query.get();

    final years = results
        .map((row) => row.read(_db.diaries.date)!.year)
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    return years;
  }

  Future<bool> deleteDiary(int diaryId) async {
    try {
      await _taskRepo.deleteTasksByDiaryId(diaryId);
      await _imageRepo.deleteImageByDiaryId(diaryId);
      await (_db.delete(_db.diaries)..where((d) => d.id.equals(diaryId))).go();
      return true;
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    _db.close();
    _taskRepo.dispose();
    _imageRepo.dispose();
  }
}
