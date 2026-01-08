import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:the_notebook/core/providers/repository_providers.dart';
import 'package:the_notebook/features/diary/domain/diary.dart';
import 'package:the_notebook/features/diary/domain/task.dart';
import 'package:the_notebook/features/diary/presentation/pages/diary_form.dart';
import 'package:the_notebook/features/diary/presentation/widgets/image_gallery.dart';
import 'package:the_notebook/features/diary/presentation/widgets/label_chip.dart';
import 'package:the_notebook/features/diary/presentation/widgets/task_card.dart';

class DiaryDetailPage extends ConsumerStatefulWidget {
  final Diary diary;

  const DiaryDetailPage({
    super.key,
    required this.diary,
  });

  @override
  ConsumerState<DiaryDetailPage> createState() => _DiaryDetailPageState();
}

class _DiaryDetailPageState extends ConsumerState<DiaryDetailPage> {
  late final diaryRepository = ref.read(diaryRepositoryProvider);
  late final taskRepository = ref.read(taskRepositoryProvider);

  late List<bool> expanded;
  late Diary currentDiary;
  bool wasEdited = false;

  @override
  void initState() {
    super.initState();
    currentDiary = widget.diary;
    expanded = List<bool>.generate(
        widget.diary.tasks?.length ?? 0, (index) => false,
        growable: true);
  }

  void onToggleParentTask(int index) {
    final task = currentDiary.tasks![index];
    final bool newState = !task.isCompleted;

    setState(() {
      currentDiary.tasks![index] = Task(
        id: task.id,
        title: task.title,
        isCompleted: newState,
        subtasks: task.subtasks
            ?.map((sub) => Task(
                  id: sub.id,
                  title: sub.title,
                  isCompleted: newState,
                  parentTaskId: task.id,
                ))
            .toList(),
      );
    });
  }

  void onToggleSubtask(int parentIndex, int subIndex) {
    final parent = currentDiary.tasks![parentIndex];
    final subtasks = [...parent.subtasks!];

    subtasks[subIndex] = Task(
      id: subtasks[subIndex].id,
      title: subtasks[subIndex].title,
      isCompleted: !subtasks[subIndex].isCompleted,
      parentTaskId: parent.id,
    );

    final allCompleted = subtasks.every((t) => t.isCompleted);

    setState(() {
      currentDiary.tasks![parentIndex] = Task(
        id: parent.id,
        title: parent.title,
        isCompleted: allCompleted,
        subtasks: subtasks,
      );
    });
  }

  void onDeleteTask(int index) async {
    final task = currentDiary.tasks![index];
    if (task.id == null) return;

    final success = await taskRepository.deleteTask(task.id!);
    if (success && mounted) {
      setState(() {
        final updatedTasks = [...currentDiary.tasks!];
        updatedTasks.removeAt(index);
        expanded.removeAt(index);
        currentDiary = Diary(
          id: currentDiary.id,
          notebookId: currentDiary.notebookId,
          time: currentDiary.time,
          title: currentDiary.title,
          date: currentDiary.date,
          content: currentDiary.content,
          images: currentDiary.images,
          tasks: updatedTasks.isEmpty ? null : updatedTasks,
        );
        wasEdited = true;
      });
    }
  }

  void onDeleteSubtask(int parentIndex, int subIndex) async {
    final parent = currentDiary.tasks![parentIndex];
    final subtask = parent.subtasks![subIndex];
    if (subtask.id == null) return;

    final success = await taskRepository.deleteTask(subtask.id!);
    if (success && mounted) {
      setState(() {
        final updatedSubtasks = [...parent.subtasks!];
        updatedSubtasks.removeAt(subIndex);
        currentDiary.tasks![parentIndex] = Task(
          id: parent.id,
          title: parent.title,
          isCompleted: parent.isCompleted,
          subtasks: updatedSubtasks.isEmpty ? null : updatedSubtasks,
        );
        wasEdited = true;
      });
    }
  }

  void onEdit() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DiaryFormPage(
                  diary: currentDiary,
                )));

    if (result == true) {
      final updatedDiary = await diaryRepository.getDiaryById(widget.diary.id!);

      // Replace this page with updated diary data
      if (mounted && updatedDiary != null) {
        setState(() {
          currentDiary = updatedDiary;
          expanded = List<bool>.generate(
              updatedDiary.tasks?.length ?? 0, (index) => false,
              growable: true);
          wasEdited = true;
        });
      }
    }
  }

  void onDelete() async {
    final result = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Delete diary'),
              content: Text('Are you sure? This can not be undone'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text('Cancel')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text('Delete')),
              ],
            ));

    if (result) {
      final success = await diaryRepository.deleteDiary(currentDiary.id!);
      if (success && mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, wasEdited);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        actions: [
          IconButton(onPressed: onEdit, icon: Icon(Icons.edit_note_outlined)),
          Padding(
            padding: const EdgeInsets.all(8),
            child: PopupMenuButton<String>(
              icon: Icon(Icons.more_horiz),
              onSelected: (value) {
                if (value == 'info') onEdit();
                if (value == 'delete') onDelete();
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                    value: 'info',
                    child: Row(
                      spacing: 10,
                      children: [Icon(Icons.info_outline), Text('Info')],
                    )),
                PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      spacing: 10,
                      children: [Icon(Icons.delete), Text('Delete')],
                    )),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 20,
                  ),
                  Text(DateFormat('MMMM, dd, yyyy').format(currentDiary.date),
                      style: TextStyle(fontSize: 18))
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 5,
                  children: [
                    LabelChip(
                      icon: Icon(
                        Icons.access_time,
                        size: 18,
                      ),
                      time: currentDiary.time,
                    ),
                    if (currentDiary.tags != null)
                      for (var tag in currentDiary.tags!) ...[
                        LabelChip(
                          icon: Icon(
                            Icons.tag,
                            size: 18,
                          ),
                          tag: tag.name,
                        ),
                      ],
                    LabelChip(
                      icon: Icon(
                        Icons.fiber_manual_record_outlined,
                        size: 18,
                      ),
                      date: currentDiary.date,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                currentDiary.title,
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                currentDiary.content!,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 16,
              ),
              if (currentDiary.images != null &&
                  currentDiary.images!.isNotEmpty) ...[
                ImageGalleryWidget(
                  images: currentDiary.images!
                      .map((img) => XFile(img.imagePath))
                      .toList(),
                  isLandscape: currentDiary.images!
                      .map((img) => img.isLandscape)
                      .toList(),
                  showRemoveButton: false,
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
              if (currentDiary.tasks != null &&
                  currentDiary.tasks!.isNotEmpty) ...[
                const Text('Task', style: TextStyle(fontSize: 18)),
                const SizedBox(
                  height: 16,
                ),
                ...currentDiary.tasks!.asMap().entries.map((entry) {
                  int index = entry.key;
                  Task task = entry.value;
                  return TaskCard(
                    task: task,
                    onToggleParentTask: () => onToggleParentTask(index),
                    onToggleSubtask: (subIndex) =>
                        onToggleSubtask(index, subIndex),
                    isExpanded: expanded[index],
                    onExpandChanged: (val) {
                      setState(() {
                        expanded[index] = val;
                      });
                    },
                    onDelete: () => onDeleteTask(index),
                    onDeleteSubtask: (subIndex) =>
                        onDeleteSubtask(index, subIndex),
                  );
                }),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
