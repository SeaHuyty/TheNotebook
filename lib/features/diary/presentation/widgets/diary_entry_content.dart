import 'package:flutter/material.dart';
import 'package:the_notebook/features/diary/domain/diary.dart';
import 'package:the_notebook/features/diary/domain/task.dart';
import 'package:the_notebook/features/diary/presentation/widgets/image_widget.dart';
import 'package:the_notebook/features/diary/presentation/widgets/task_card.dart';

class DiaryEntryContent extends StatefulWidget {
  final Diary diary;

  const DiaryEntryContent({
    super.key,
    required this.diary,
  });

  @override
  State<DiaryEntryContent> createState() => _DiaryEntryContentState();
}

class _DiaryEntryContentState extends State<DiaryEntryContent> {
  late List<bool> expanded;

  @override
  void initState() {
    super.initState();
    expanded = List<bool>.generate(widget.diary.tasks?.length ?? 0, (index) => false,
        growable: true);
  }

  @override
  void didUpdateWidget(DiaryEntryContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.diary.tasks?.length != widget.diary.tasks?.length) {
      expanded = List<bool>.generate(
          widget.diary.tasks?.length ?? 0, (index) => false,
          growable: true);
    }
  }

  void onToggleParentTask(int index) {
    final task = widget.diary.tasks![index];
    final bool newState = !task.isCompleted;

    setState(() {
      widget.diary.tasks![index] = Task(
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
    final parent = widget.diary.tasks![parentIndex];
    final subtasks = [...parent.subtasks!];

    subtasks[subIndex] = Task(
      id: subtasks[subIndex].id,
      title: subtasks[subIndex].title,
      isCompleted: !subtasks[subIndex].isCompleted,
      parentTaskId: parent.id,
    );

    final allCompleted = subtasks.every((t) => t.isCompleted);

    setState(() {
      widget.diary.tasks![parentIndex] = Task(
        id: parent.id,
        title: parent.title,
        isCompleted: allCompleted,
        parentTaskId: parent.parentTaskId,
        subtasks: subtasks,
      );
    });
  }

  void onDelete() {}

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.diary.image != null) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ImageWidget(
                image: widget.diary.image!,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            widget.diary.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(widget.diary.content!, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          if (widget.diary.tasks != null) ...[
            ...widget.diary.tasks!.asMap().entries.map((entry) {
              int index = entry.key;
              Task task = entry.value;
              return TaskCard(
                task: task,
                onToggleParentTask: () => onToggleParentTask(index),
                onToggleSubtask: (subIndex) => onToggleSubtask(index, subIndex),
                isExpanded: expanded[index],
                onExpandChanged: (val) {
                  setState(() {
                    expanded[index] = val;
                  });
                },
              );
            }),
          ],
        ],
      ),
    );
  }
}
