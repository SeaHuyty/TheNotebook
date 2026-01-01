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
  late Diary currentDiary;
  bool wasEdited = false;

  @override
  void initState() {
    super.initState();
    currentDiary = widget.diary;
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
      if (mounted && updatedDiary != null) {
        setState(() {
          currentDiary = updatedDiary;
          wasEdited = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, wasEdited);
            },
            icon: Icon(Icons.arrow_back_ios)),
        actions: [TextButton(onPressed: onEdit, child: Text('Edit'))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
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
                Text(currentDiary.date.toString())
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
              currentDiary.content,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 16,
            ),
            if (currentDiary.image != null) ...[
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ImageWidget(image: currentDiary.image!)),
              const SizedBox(
                height: 16,
              ),
            ],
            if (currentDiary.tasks != null &&
                currentDiary.tasks!.isNotEmpty) ...[
              const Text('Task', style: TextStyle(fontSize: 18)),
              const SizedBox(
                height: 16,
              ),
              ...currentDiary.tasks!.asMap().entries.map((entry) {
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
