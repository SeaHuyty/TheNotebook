import 'package:flutter/material.dart';
import 'package:the_notebook/features/diary/domain/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggleParentTask;
  final Function onToggleSubtask;
  final bool isExpanded;
  final ValueChanged<bool> onExpandChanged;
  final VoidCallback onDelete;

  const TaskCard(
      {super.key,
      required this.task,
      required this.onToggleParentTask,
      required this.onToggleSubtask,
      required this.isExpanded,
      required this.onExpandChanged,
      required this.onDelete});

  Color get radioColor =>
      task.isCompleted ? Colors.green[500]! : Colors.transparent;

  Border? get radioBorder =>
      task.isCompleted ? null : Border.all(color: Colors.grey, width: 2);

  IconData? get radioIcon => task.isCompleted ? Icons.check : null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: onToggleParentTask,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: radioColor,
                  border: radioBorder,
                ),
                child: radioIcon != null
                    ? Icon(radioIcon, size: 12, color: Colors.white)
                    : const SizedBox.shrink(),
              ),
            ),
            const SizedBox(width: 10),
            Text(task.title),
            Row(
              children: [
                IconButton(
                    onPressed: () => onExpandChanged(!isExpanded),
                    icon: AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(Icons.expand_circle_down_outlined),
                    )),
                IconButton(
                    onPressed: onDelete,
                    icon: Icon(
                      Icons.remove_circle_outline,
                      color: Colors.red,
                    ))
              ],
            )
          ],
        ),
      ],
    );
  }
}
