import 'package:flutter/material.dart';
import 'package:the_notebook/features/diary/domain/task.dart';

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

  Color get radioColor =>
      task.isCompleted ? Colors.green[500]! : Colors.transparent;

  Border? get radioBorder =>
      task.isCompleted ? null : Border.all(color: Colors.grey, width: 2);

  IconData? get radioIcon => task.isCompleted ? Icons.check : null;

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
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              leading: GestureDetector(
                onTap: onToggleParentTask,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 20,
                  height: 20,
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

class SubTaskList extends StatelessWidget {
  final List<Task> subtasks;
  final Function(int) onToggle;
  final Function(int)? onDelete;

  const SubTaskList({
    super.key,
    required this.subtasks,
    required this.onToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[100]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // GREY CONNECTOR LINE
          Padding(
            padding: EdgeInsets.only(left: 25),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 2,
                height: subtasks.length * 48.0,
                color: Colors.grey.shade300,
              ),
            ),
          ),

          // SUBTASKS
          Expanded(
            child: Column(
              children: subtasks.asMap().entries.map((entry) {
                int index = entry.key;
                Task task = entry.value;
                return Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: SubtaskTile(
                    task: task,
                    onToggle: () => onToggle(index),
                    onDelete: onDelete != null ? () => onDelete!(index) : null,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class SubtaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback? onDelete;

  const SubtaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Radio(
        checked: task.isCompleted,
        onTap: onToggle,
      ),
      title: Text(
        task.title,
        style: const TextStyle(fontSize: 16),
      ),
      trailing: onDelete != null
          ? IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
              onPressed: onDelete,
            )
          : null,
    );
  }
}

class Radio extends StatelessWidget {
  final bool checked;
  final VoidCallback onTap;
  final double size;

  const Radio({
    super.key,
    required this.checked,
    required this.onTap,
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: checked ? null : Border.all(color: Colors.grey, width: 2),
          color: checked ? Colors.green : Colors.transparent,
        ),
        child: checked
            ? const Icon(Icons.check, size: 12, color: Colors.white)
            : null,
      ),
    );
  }
}
