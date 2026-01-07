import 'package:flutter/material.dart';
import 'package:the_notebook/features/diary/domain/task.dart';
import 'package:the_notebook/features/diary/presentation/widgets/custom_radio.dart';
import 'package:the_notebook/features/diary/presentation/widgets/subtask_list.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggleParentTask;
  final Function onToggleSubtask;
  final bool isExpanded;
  final ValueChanged<bool> onExpandChanged;
  final VoidCallback? onDelete;
  final Function(int)? onDeleteSubtask;

  const TaskCard(
      {super.key,
      required this.task,
      required this.onToggleParentTask,
      required this.onToggleSubtask,
      required this.isExpanded,
      required this.onExpandChanged,
      this.onDelete,
      this.onDeleteSubtask});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(12),
              bottom: isExpanded ? Radius.zero : const Radius.circular(12),
            ),
          ),
          child: Center(
            child: ListTile(
              title: Text(
                task.title,
                style: const TextStyle(fontSize: 15),
              ),
              leading: CustomRadio(
                  checked: task.isCompleted,
                  onTap: onToggleParentTask,
                  size: 20),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () => onExpandChanged(!isExpanded),
                      icon: AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(Icons.expand_circle_down_outlined),
                      )),
                  if (onDelete != null)
                    IconButton(
                        onPressed: onDelete,
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: Colors.red,
                        ))
                ],
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child:
              isExpanded && task.subtasks != null && task.subtasks!.isNotEmpty
                  ? SubTaskList(
                      subtasks: task.subtasks!,
                      onToggle: (subtaskIndex) => onToggleSubtask(subtaskIndex),
                      onDelete: onDeleteSubtask,
                    )
                  : const SizedBox.shrink(),
        ),
      ],
    );
  }
}