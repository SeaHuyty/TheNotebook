import 'package:flutter/material.dart';
import 'package:the_notebook/features/diary/domain/diary.dart';
import 'package:the_notebook/features/diary/domain/task.dart';
import 'package:the_notebook/features/diary/presentation/pages/edit_diary.dart';
import 'package:the_notebook/features/diary/presentation/widgets/build_image.dart';
import 'package:the_notebook/features/diary/presentation/widgets/task_card.dart';

class DiaryDetailPage extends StatefulWidget {
  final Diary diary;

  const DiaryDetailPage({super.key, required this.diary});

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

  void onEdit() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditDiaryPage(diary: widget.diary)));
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
                Icon(
                  Icons.calendar_today_outlined,
                  size: 20,
                ),
                Text(widget.diary.date.toString())
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'A Productive Title',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              widget.diary.content,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 16,
            ),
            if (widget.diary.imageUrl != null) ...[
              ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(10),
                  child: ImageWidget(imagePath: widget.diary.imageUrl!)),
              SizedBox(
                height: 16,
              ),
            ],
            if (widget.diary.tasks != null) ...[
              Text('Task', style: TextStyle(fontSize: 18)),
              SizedBox(
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
