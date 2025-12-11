import 'package:flutter/material.dart';
import 'package:minimal_diary/features/todo/domain/task.dart';
import 'package:minimal_diary/features/todo/presentation/widgets/task_card.dart';
import 'package:minimal_diary/features/todo/presentation/widgets/task_stat.dart';
import '../../../../shared/widgets/app_drawer.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
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
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('My task'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
      ),
      drawer: AppDrawer(currentPage: 'todo'),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                TaskStat(),
                SizedBox(width: 10),
                TaskStat(),
                SizedBox(width: 10),
                TaskStat(),
              ],
            ),

            SizedBox(height: 20),

            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Today",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 10),

                        TaskCard(
                          task: tasks[index],
                          isExpanded: expanded[index],
                          onExpandChanged: (val) {
                            setState(() {
                              expanded[index] = val;
                            });
                          },
                        ),

                        SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
