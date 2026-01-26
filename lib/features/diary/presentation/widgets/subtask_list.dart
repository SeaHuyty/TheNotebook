import 'package:flutter/material.dart';
import 'package:the_notebook/core/models/task.dart';
import 'package:the_notebook/features/diary/presentation/widgets/custom_radio.dart';

class SubTaskList extends StatelessWidget {
  final List<TaskModel> subtasks;
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
      decoration: BoxDecoration(color: Colors.white),
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
                TaskModel task = entry.value;
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
  final TaskModel task;
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
      leading: CustomRadio(
        checked: task.isCompleted,
        onTap: onToggle,
      ),
      title: Text(
        task.title,
        style: const TextStyle(fontSize: 14),
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
