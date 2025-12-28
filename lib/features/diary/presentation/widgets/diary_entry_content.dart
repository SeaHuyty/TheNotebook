import 'package:flutter/material.dart';
import 'package:the_notebook/features/diary/domain/task.dart';
import 'package:the_notebook/features/diary/presentation/widgets/task_card.dart';

class DiaryEntryContent extends StatefulWidget {
  final String date;
  final String content;
  final String? imageUrl;
  final List<Task>? tasks;

  const DiaryEntryContent({
    super.key,
    required this.date,
    required this.content,
    this.tasks,
    this.imageUrl,
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
    );
  }
}
