import 'package:the_notebook/core/database/seed/diary_data.dart';
import 'package:the_notebook/features/diary/data/repositories/diary_repository.dart';
import 'package:the_notebook/features/diary/data/repositories/tag_repository.dart';
import 'package:the_notebook/core/models/tag.dart';
import 'package:the_notebook/core/models/notebook.dart';
import 'package:the_notebook/core/models/diary.dart';
import 'package:the_notebook/features/notebook/data/repository/notebook_repository.dart';
import 'package:the_notebook/features/setting/data/repositories/user_repository.dart';

class SeedIndex {
  final NotebookRepository _noteRepo = NotebookRepository();
  final DiaryRepository _diaryRepo = DiaryRepository();
  final TagRepository _tagRepo = TagRepository();
  final UserRepository _userRepo = UserRepository();

  final notebook =
      NotebookModel(title: 'Starter', icon: 'assets/images/home.png');

  Future<void> seedIfEmpty() async {
    final notebooks = await _noteRepo.getNotebooks();
    if (notebooks.isNotEmpty) return;

    final notebookId = await _noteRepo.insertNotebook(notebook);

    await _userRepo.createUser(notebookId); 

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
      final tagId = await _tagRepo.insertTag(TagModel(name: tagName));
      tagNameToId[tagName] = tagId;
    }

    for (var diary in sampleDiaries) {
      List<TagModel>? tagsWithIds;

      if (diary.tags != null) {
        tagsWithIds = diary.tags!.map((tag) {
          return TagModel(name: tag.name, id: tagNameToId[tag.name]);
        }).toList();
      }

      final updatedDiary = DiaryModel(
          content: diary.content,
          title: diary.title,
          time: diary.time,
          tags: tagsWithIds,
          notebookId: notebookId,
          date: diary.date,
          images: diary.images,
          tasks: diary.tasks);

      await _diaryRepo.insertDiary(updatedDiary);
    }
  }
}
