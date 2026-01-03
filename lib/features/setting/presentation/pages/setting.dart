import 'package:flutter/material.dart';
import 'package:the_notebook/features/diary/data/repositories/diary_repository.dart';
import 'package:the_notebook/features/diary/data/repositories/task_repository.dart';
import 'package:the_notebook/features/notebook/data/repository/notebook_repository.dart';
import 'package:the_notebook/shared/widgets/app_drawer.dart';

class SettingPage extends StatelessWidget {
  final DiaryRepository? diaryRepo;
  final NotebookRepository? notebookRepo;
  final TaskRepository? taskRepo;

  const SettingPage(
      {super.key, required this.diaryRepo, this.notebookRepo, this.taskRepo});

  void onReset() {
    // Reset the configuration to default
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'reset') onReset();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'reset',
                  child: Row(
                spacing: 10,
                children: [Icon(Icons.autorenew), Text('Reset')],
              ))
            ],
          ),
        ],
      ),
      drawer: AppDrawer(
        currentPage: 'setting',
        diaryRepo: diaryRepo,
        notebookRepo: notebookRepo,
        taskRepo: taskRepo,
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Languages'),
            subtitle: Text('English'),
          ),
          ListTile(
            leading: Icon(Icons.light_mode_outlined),
            title: Text('Theme Mode'),
            subtitle: Text('Light mode'),
          ),
          ListTile(
            leading: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: Center(
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue, // hard-coded theme color
                  ),
                ),
              ),
            ),
            title: Text('Color Seed'),
            subtitle: Text('Custom'),
          ),
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text('Time Format'),
            subtitle: Text('24-Hour'),
          ),
          ListTile(
            leading: Icon(Icons.lock_outline_rounded),
            title: Text('App Lock'),
          ),
        ],
      ),
    );
  }
}
