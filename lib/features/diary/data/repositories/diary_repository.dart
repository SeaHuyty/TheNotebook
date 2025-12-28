import 'package:the_notebook/features/diary/domain/task.dart';
import 'package:the_notebook/features/diary/domain/diary.dart';
import 'package:the_notebook/features/diary/data/seed_data.dart';

class DiaryRepository {
  final List<Diary> _diaries = [];
  int _nextDiaryId = 1;
  int _nextTaskId = 1;

  DiaryRepository();

  Future<List<Diary>> getDiaryEntries() async {
    final result = List<Diary>.from(_diaries);
    result.sort((a, b) => a.date.compareTo(b.date));
    return result;
  }

  Future<void> seedIfEmpty() async {
    if (_diaries.isNotEmpty) return;

    for (var entry in sampleDiaries) {
      await insertDiary(entry);
    }
  }

  Future<int> insertDiary(Diary diary) async {
    final diaryId = _nextDiaryId++;

    final List<Task>? processedTasks;
    if (diary.tasks != null) {
      processedTasks = diary.tasks!.map((task) {
        final taskId = _nextTaskId++;

        final List<Task>? processedSubtasks;
        if (task.subtasks != null) {
          processedSubtasks = task.subtasks!.map((subtask) {
            final subtaskId = _nextTaskId++;
            return Task(
              id: subtaskId,
              title: subtask.title,
              isDone: subtask.isDone ?? false,
              diaryId: diaryId,
              parentTaskId: taskId,
            );
          }).toList();
        } else {
          processedSubtasks = null;
        }

        return Task(
          id: taskId,
          title: task.title,
          isDone: task.isDone ?? false,
          diaryId: diaryId,
          subtasks: processedSubtasks,
        );
      }).toList();
    } else {
      processedTasks = null;
    }

    final newDiary = Diary(
      id: diaryId,
      date: diary.date,
      content: diary.content,
      imageUrl: diary.imageUrl,
      tasks: processedTasks,
    );

    _diaries.add(newDiary);
    return diaryId;
  }
}
