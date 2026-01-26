import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:the_notebook/features/diary/data/repositories/tag_repository.dart';
import 'package:the_notebook/core/models/diary.dart';
import 'package:the_notebook/core/database/database.dart';
import 'package:the_notebook/features/diary/data/repositories/task_repository.dart';
import 'package:the_notebook/features/diary/data/repositories/diary_image_repository.dart';

class DiaryRepository {
  final AppDatabase _db = AppDatabase();
  final TaskRepository _taskRepo = TaskRepository();
  final DiaryImageRepository _imageRepo = DiaryImageRepository();
  final TagRepository _tagRepo = TagRepository();

  DiaryRepository();

  Future<List<DiaryModel>> getDiaryEntries() async {
    final diaries = await _db.select(_db.diaries).get();
    final result = <DiaryModel>[];

    for (var diary in diaries) {
      final tasks = await _taskRepo.getTasksForDiary(diary.id);
      final image = await _imageRepo.getImagesByDiaryId(diary.id);
      final tags = await _tagRepo.getTagsForDiary(diary.id);

      final parts = diary.time.split(':');

      result.add(
        DiaryModel(
          notebookId: diary.notebookId,
          id: diary.id,
          title: diary.title,
          time:
              TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1])),
          tags: tags,
          date: diary.date,
          content: diary.content,
          images: image,
          tasks: tasks,
        ),
      );
    }

    result.sort((a, b) => a.date.compareTo(b.date));
    return result;
  }

  Future<int> insertDiary(DiaryModel diary) async {
    final timeString =
        '${diary.time.hour.toString().padLeft(2, '0')}:${diary.time.minute.toString().padLeft(2, '0')}';
    final diaryId = await _db.into(_db.diaries).insert(
          DiariesCompanion(
            notebookId: Value(diary.notebookId),
            title: Value(diary.title),
            time: Value(timeString),
            date: Value(diary.date),
            content: Value(diary.content),
          ),
        );

    if (diary.tags != null) {
      for (var tag in diary.tags!) {
        if (tag.id != null) {
          await _db.into(_db.diaryTags).insert(DiaryTagsCompanion(
              diaryId: Value(diaryId), tagId: Value(tag.id!)));
        }
      }
    }

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

    if (diary.images != null) {
      for (var image in diary.images!) {
        await _imageRepo.insertImage(image, diaryId);
      }
    }

    return diaryId;
  }

  Future<void> updateDiary(DiaryModel diary,
      {bool contentChanged = false,
      bool timeChanged = false,
      bool tagChanged = false,
      bool dateChanged = false,
      bool imageChanged = false,
      bool taskChanged = false}) async {
    if (contentChanged || dateChanged) {
      await (_db.update(_db.diaries)..where((d) => d.id.equals(diary.id!)))
          .write(DiariesCompanion(
        content: contentChanged ? Value(diary.content) : Value.absent(),
        date: dateChanged ? Value(diary.date) : Value.absent(),
      ));
    }

    if (timeChanged) {
      final timeString =
          '${diary.time.hour.toString().padLeft(2, '0')}:${diary.time.minute.toString().padLeft(2, '0')}';
      await (_db.update(_db.diaries)..where((d) => d.id.equals(diary.id!)))
          .write(DiariesCompanion(time: Value(timeString)));
    }

    if (tagChanged) {
      // await (_db.update(_db.diaries)..where((d) => d.id.equals(diary.id!)))
      // .write(DiaryTags()));
    }

    if (imageChanged) {
      await _imageRepo.deleteImageByDiaryId(diary.id!);

      if (diary.images != null) {
        for (var image in diary.images!) {
          await _imageRepo.insertImage(image, diary.id!);
        }
      }
    }

    if (taskChanged) {
      await _taskRepo.deleteTasksByDiaryId(diary.id!);

      if (diary.tasks != null) {
        for (var task in diary.tasks!) {
          final taskId = await _taskRepo.insertTask(task, diary.id!);

          if (task.subtasks != null) {
            for (var subtask in task.subtasks!) {
              await _db.into(_db.tasks).insert(
                    TasksCompanion(
                      title: Value(subtask.title),
                      isCompleted: Value(subtask.isCompleted),
                      diaryId: Value(diary.id!),
                      parentTaskId: Value(taskId),
                    ),
                  );
            }
          }
        }
      }
    }
  }

  Future<DiaryModel?> getDiaryById(int diaryId) async {
    final tasks = await _taskRepo.getTasksForDiary(diaryId);
    final image = await _imageRepo.getImagesByDiaryId(diaryId);
    final tags = await _tagRepo.getTagsForDiary(diaryId);

    final query = _db.select(_db.diaries)
      ..where((tbl) => tbl.id.equals(diaryId));

    final diary = await query.getSingleOrNull();
    if (diary == null) return null;

    final parts = diary.time.split(':');

    return DiaryModel(
      id: diary.id,
      notebookId: diary.notebookId,
      title: diary.title,
      time: TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1])),
      tags: tags,
      date: diary.date,
      content: diary.content,
      images: image,
      tasks: tasks,
    );
  }

  Future<List<DiaryModel>> getDiaryEntriesByYear(
      int year, int notebookId) async {
    final startOfYear = DateTime(year, 1, 1);
    final endOfYear = DateTime(year, 12, 31, 23, 59, 59);

    final query = _db.select(_db.diaries)
      ..where((tbl) =>
          tbl.date.isBiggerOrEqualValue(startOfYear) &
          tbl.date.isSmallerOrEqualValue(endOfYear) &
          tbl.notebookId.equals(notebookId));

    final result = await query.get();
    final diaries = <DiaryModel>[];

    for (var diary in result) {
      final tasks = await _taskRepo.getTasksForDiary(diary.id);
      final image = await _imageRepo.getImagesByDiaryId(diary.id);
      final tags = await _tagRepo.getTagsForDiary(diary.id);

      final parts = diary.time.split(':');

      diaries.add(
        DiaryModel(
            id: diary.id,
            notebookId: diary.notebookId,
            date: diary.date,
            title: diary.title,
            time: TimeOfDay(
                hour: int.parse(parts[0]), minute: int.parse(parts[1])),
            content: diary.content,
            tags: tags,
            images: image,
            tasks: tasks),
      );
    }

    diaries.sort((a, b) => a.date.compareTo(b.date));
    return diaries;
  }

  Future<List<int>> getAvailableYears(int notebookId) async {
    final query = _db.selectOnly(_db.diaries)
      ..where(_db.diaries.notebookId.equals(notebookId))
      ..addColumns([_db.diaries.date]);

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
    _tagRepo.dispose();
  }
}
