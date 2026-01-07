import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_notebook/features/diary/data/repositories/diary_repository.dart';
import 'package:the_notebook/features/diary/data/repositories/diary_tag_repository.dart';
import 'package:the_notebook/features/diary/data/repositories/tag_repository.dart';
import 'package:the_notebook/features/diary/data/repositories/task_repository.dart';
import 'package:the_notebook/features/notebook/data/repository/notebook_repository.dart';

final diaryRepositoryProvider = Provider<DiaryRepository>((ref) {
  return DiaryRepository();
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository();
});

final tagRepositoryProvider = Provider<TagRepository>((ref) {
  return TagRepository();
});

final diaryTagRepositoryProvider = Provider<DiaryTagRepository>((ref) {
  return DiaryTagRepository();
});

final notebookRepositoryProvider = Provider<NotebookRepository>((ref) {
  return NotebookRepository();
});