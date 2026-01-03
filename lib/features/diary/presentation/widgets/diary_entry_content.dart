import 'package:flutter/material.dart';
import 'package:the_notebook/features/diary/domain/diary_image.dart';
import 'package:the_notebook/features/diary/domain/task.dart';
import 'package:the_notebook/features/diary/presentation/widgets/image_widget.dart';
import 'package:the_notebook/features/diary/presentation/widgets/task_card.dart';

class DiaryEntryContent extends StatefulWidget {
  final String date;
  final String content;
  final DiaryImage? image;
  final List<Task>? tasks;

  const DiaryEntryContent({
    super.key,
    required this.date,
    required this.content,
    this.tasks,
    this.image,
  });

  @override
  State<DiaryEntryContent> createState() => _DiaryEntryContentState();
}

class _DiaryEntryContentState extends State<DiaryEntryContent> {
  late final List<bool> expanded;

  @override
  void initState() {
    super.initState();
    expanded = List<bool>.filled(widget.tasks?.length ?? 0, false);
  }

  void onToggleParentTask(int index) {
    final task = widget.tasks![index];
    final bool newState = !task.isCompleted;

    setState(() {
      widget.tasks![index] = Task(
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
    final parent = widget.tasks![parentIndex];
    final subtasks = [...parent.subtasks!];

    subtasks[subIndex] = Task(
      id: subtasks[subIndex].id,
      title: subtasks[subIndex].title,
      isCompleted: !subtasks[subIndex].isCompleted,
      parentTaskId: parent.id,
    );

    final allCompleted = subtasks.every((t) => t.isCompleted);

    setState(() {
      widget.tasks![parentIndex] = Task(
        id: parent.id,
        title: parent.title,
        isCompleted: allCompleted,
        subtasks: subtasks,
      );
    });
  }

  void onDelete() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.image != null) ...[
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ImageWidget(
              image: widget.image!,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Text(
          widget.date,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(widget.content, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 8),
        if (widget.tasks != null) ...[
          ...widget.tasks!.asMap().entries.map((entry) {
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
              onDelete: onDelete,
            );
          }),
        ],
      ],
    );
  }
}
