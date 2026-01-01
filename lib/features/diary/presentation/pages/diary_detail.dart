import 'package:flutter/material.dart';
import 'package:the_notebook/features/diary/data/repositories/diary_repository.dart';
import 'package:the_notebook/features/diary/domain/diary.dart';
import 'package:the_notebook/features/diary/domain/task.dart';
import 'package:the_notebook/features/diary/presentation/pages/edit_diary.dart';
import 'package:the_notebook/features/diary/presentation/widgets/image_widget.dart';
import 'package:the_notebook/features/diary/presentation/widgets/task_card.dart';

class DiaryDetailPage extends StatefulWidget {
  final Diary diary;
  final DiaryRepository repo;

  const DiaryDetailPage({super.key, required this.diary, required this.repo});

  @override
  State<DiaryDetailPage> createState() => _DiaryDetailPageState();
}

class _DiaryDetailPageState extends State<DiaryDetailPage> {
  late final List<bool> expanded;

  @override
  void initState() {
    super.initState();
    expanded = List<bool>.filled(widget.diary.tasks?.length ?? 0, false);
  }

  void onEdit() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                EditDiaryPage(diary: widget.diary, repo: widget.repo)));

    if (result == true) {
      final updatedDiary = await widget.repo.getDiaryById(widget.diary.id!);

      // Replace this page with updated diary data
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DiaryDetailPage(
              diary: updatedDiary!,
              repo: widget.repo,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [TextButton(onPressed: onEdit, child: Text('Edit'))],
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(15),
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
                Text(widget.diary.date.toString())
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
              widget.diary.content,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 16,
            ),
            if (widget.diary.image != null) ...[
              ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(10),
                  child: ImageWidget(image: widget.diary.image!)),
              const SizedBox(
                height: 16,
              ),
            ],
            if (widget.diary.tasks != null &&
                widget.diary.tasks!.isNotEmpty) ...[
              const Text('Task', style: TextStyle(fontSize: 18)),
              const SizedBox(
                height: 16,
              ),
              ...widget.diary.tasks!.asMap().entries.map((entry) {
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
        ),
      ),
    );
  }
}
