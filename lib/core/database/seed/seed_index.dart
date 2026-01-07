import 'package:the_notebook/core/database/seed/diary_data.dart';
import 'package:the_notebook/features/diary/data/repositories/diary_repository.dart';
import 'package:the_notebook/features/diary/data/repositories/tag_repository.dart';
import 'package:the_notebook/features/diary/domain/tag.dart' as domain;
import 'package:the_notebook/features/notebook/model/notebook.dart' as domain;
import 'package:the_notebook/features/diary/domain/diary.dart' as domain;
import 'package:the_notebook/features/notebook/data/repository/notebook_repository.dart';

class SeedIndex {
  final NotebookRepository _noteRepo = NotebookRepository();
  final DiaryRepository _diaryRepo = DiaryRepository();
  final TagRepository _tagRepo = TagRepository();

  final notebook =
      domain.Notebook(title: 'Starter', icon: 'assets/images/home.png');

  Future<void> seedIfEmpty() async {
    final notebooks = await _noteRepo.getNotebooks();
    if (notebooks.isNotEmpty) return;

    final notebookId = await _noteRepo.insertNotebook(notebook);

    final Map<String, int> tagNameToId = {};
    final Set<String> allTagNames = {};

    for (var diary in sampleDiaries) {
      if (diary.tags != null) {
        for (var tag in diary.tags!) {
          allTagNames.add(tag.name);
        }
      }
    }

    for (var tagName in allTagNames) {
      final tagId = await _tagRepo.insertTag(domain.Tag(name: tagName));
      tagNameToId[tagName] = tagId;
    }

    for (var diary in sampleDiaries) {
      List<domain.Tag>? tagsWithIds;

      if (diary.tags != null) {
        tagsWithIds = diary.tags!.map((tag) {
          return domain.Tag(name: tag.name, id: tagNameToId[tag.name]);
        }).toList();
      }

      final updatedDiary = domain.Diary(
          content: diary.content,
          title: diary.title,
          time: diary.time,
          tags: tagsWithIds,
          notebookId: notebookId,
          date: diary.date,
          image: diary.image,
          tasks: diary.tasks);

      await _diaryRepo.insertDiary(updatedDiary);
    }
  }
}
