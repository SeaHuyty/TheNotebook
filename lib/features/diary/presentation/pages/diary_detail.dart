import 'package:flutter/material.dart';
import 'package:the_notebook/features/diary/data/repositories/diary_repository.dart';
import 'package:the_notebook/features/diary/data/repositories/task_repository.dart';
import 'package:the_notebook/features/diary/domain/diary.dart';
import 'package:the_notebook/features/diary/domain/task.dart';
import 'package:the_notebook/features/diary/presentation/pages/edit_diary.dart';
import 'package:the_notebook/features/diary/presentation/widgets/image_widget.dart';
import 'package:the_notebook/features/diary/presentation/widgets/task_card.dart';

class DiaryDetailPage extends StatefulWidget {
  final Diary diary;
  final DiaryRepository diaryRepository;
  final TaskRepository taskRepository;

  const DiaryDetailPage(
      {super.key,
      required this.diary,
      required this.diaryRepository,
      required this.taskRepository});

  @override
  State<DiaryDetailPage> createState() => _DiaryDetailPageState();
}

class _DiaryDetailPageState extends State<DiaryDetailPage> {
  late final List<bool> expanded;
  late Diary currentDiary;
  bool wasEdited = false;

  @override
  void initState() {
    super.initState();
    currentDiary = widget.diary;
    expanded = List<bool>.filled(widget.diary.tasks?.length ?? 0, false);
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

  void onEdit() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditDiaryPage(
                  diary: widget.diary,
                  diaryRepository: widget.diaryRepository,
                  taskRepository: widget.taskRepository,
                )));

    if (result == true) {
      final updatedDiary =
          await widget.diaryRepository.getDiaryById(widget.diary.id!);

      // Replace this page with updated diary data
      if (mounted && updatedDiary != null) {
        setState(() {
          currentDiary = updatedDiary;
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
      final success =
          await widget.diaryRepository.deleteDiary(currentDiary.id!);
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
          Padding(
            padding: const EdgeInsets.all(8),
            child: PopupMenuButton<String>(
              icon: Icon(Icons.more_horiz),
              onSelected: (value) {
                if (value == 'edit') onEdit();
                if (value == 'delete') onDelete();
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      spacing: 10,
                      children: [Icon(Icons.edit), Text('Edit')],
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
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 20,
                ),
                Text(currentDiary.date.toString())
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'A Productive Title',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              currentDiary.content,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 16,
            ),
            if (currentDiary.image != null) ...[
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ImageWidget(image: currentDiary.image!)),
              const SizedBox(
                height: 16,
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
                  onDelete: onDelete,
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}
