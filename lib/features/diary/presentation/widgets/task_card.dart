import 'package:flutter/material.dart';
import 'package:minimal_diary/features/diary/domain/task.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final bool isExpanded;
  final ValueChanged<bool> onExpandChanged;

  const TaskCard({
    super.key,
    required this.task,
    required this.isExpanded,
    required this.onExpandChanged,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool isChecked = false;

  String get buttonText => widget.isExpanded ? "Collapse" : "Expand";
  IconData get buttonIcon =>
      widget.isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down;

  Color get radioColor => isChecked ? Colors.green[500]! : Colors.transparent;
  IconData? get radioIcon => isChecked ? Icons.check : null;
  Border? get radioBorder =>
      isChecked ? null : Border.all(color: Colors.grey, width: 2);

  void viewToggle() {
    widget.onExpandChanged(!widget.isExpanded);
  }

  void radioToggle() {
    setState(() {
      isChecked = !isChecked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: radioToggle,
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
                    : SizedBox.shrink(),
              ),
            ),

            SizedBox(width: 10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.task.title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 5),

                Row(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue, // text color
                      ),
                      onPressed: viewToggle,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(buttonIcon, size: 18),
                          SizedBox(width: 5),
                          Text(buttonText, style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),

                    SizedBox(width: 5),

                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue, // text color
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.add, size: 18),
                          SizedBox(width: 5),
                          Text("Add Sub-task", style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        // if (widget.task.subtasks.isNotEmpty && widget.isExpanded)
        //   Column(
        //     children: widget.task.subtasks.map((sub) {
        //       return TaskCard(
        //         task: sub,
        //         isExpanded: false,
        //         onExpandChanged: (_) {},
        //       );
        //     }).toList(),
        //   ),
      ],
    );
  }
}
