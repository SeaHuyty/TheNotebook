import 'package:flutter/material.dart';
import 'package:minimal_diary/features/todo/domain/task.dart';
import 'package:minimal_diary/features/todo/presentation/widgets/task_card.dart';

class DiaryEntryContent extends StatefulWidget {
  final String date;
  final String content;
  final String? imageUrl;

  const DiaryEntryContent({
    super.key,
    required this.date,
    required this.content,
    this.imageUrl,
  });

  @override
  State<DiaryEntryContent> createState() => _DiaryEntryContentState();
}

class _DiaryEntryContentState extends State<DiaryEntryContent> {
  late final List<Task> tasks;
  late final List<bool> expanded;
  @override
  void initState() {
    super.initState();
    tasks = [
      Task(
        title: "Complete project proposal",
        subtasks: [
          Task(title: "Write introduction"),
          Task(title: "Make diagrams"),
          Task(title: "Review with team"),
        ],
      ),
    ];
    expanded = List<bool>.filled(tasks.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.imageUrl != null) ...[
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              widget.imageUrl!,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  height: 100,
                  child: Center(child: Text('Image not found')),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
        Text(widget.date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Text(widget.content, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 8),
        TaskCard(
          task: tasks[0],
          isExpanded: expanded[0],
          onExpandChanged: (val) {
            setState(() {
              expanded[0] = val;
            });
          },
        ),
      ],
    );
  }
}
