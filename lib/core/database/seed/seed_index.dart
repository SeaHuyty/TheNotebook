import 'package:the_notebook/core/database/seed/diary_data.dart';
import 'package:the_notebook/features/diary/data/repositories/diary_repository.dart';
import 'package:the_notebook/features/notebook/model/notebook.dart' as domain;
import 'package:the_notebook/features/diary/domain/diary.dart' as domain;
import 'package:the_notebook/features/notebook/data/repository/notebook_repository.dart';

class SeedIndex {
  final NotebookRepository _noteRepo = NotebookRepository();
  final DiaryRepository _diaryRepo = DiaryRepository();

  final notebook =
      domain.Notebook(title: 'Starter', icon: 'assets/images/home.png');

  Future<void> seedIfEmpty() async {
    final notebooks = await _noteRepo.getNotebooks();
    if (notebooks.isNotEmpty) return;

    final notebookId = await _noteRepo.insertNotebook(notebook);

    for (var diary in sampleDiaries) {
      final updatedDiary = domain.Diary(
          content: diary.content,
          title: diary.title,
          time: diary.time,
          tag: diary.tag,
          notebookId: notebookId,
          date: diary.date,
          image: diary.image,
          tasks: diary.tasks);

      await _diaryRepo.insertDiary(updatedDiary);
    }
  }
}
