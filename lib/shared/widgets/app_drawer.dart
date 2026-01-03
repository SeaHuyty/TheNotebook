import 'package:flutter/material.dart';
import 'package:the_notebook/features/diary/data/repositories/diary_repository.dart';
import 'package:the_notebook/features/diary/data/repositories/task_repository.dart';
import 'package:the_notebook/features/notebook/data/repository/notebook_repository.dart';
import 'package:the_notebook/features/notebook/presentation/notebook_page.dart';
import 'package:the_notebook/features/setting/presentation/pages/setting.dart';

class AppDrawer extends StatelessWidget {
  final DiaryRepository? diaryRepo;
  final NotebookRepository? notebookRepo;
  final TaskRepository? taskRepo;
  final String currentPage;

  const AppDrawer(
      {super.key,
      required this.currentPage,
      this.diaryRepo,
      this.notebookRepo,
      this.taskRepo});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: const Border(bottom: BorderSide(color: Colors.grey)),
            ),
            child: const Text('Hello Tengyi', style: TextStyle(fontSize: 22)),
          ),
          ListTile(
            leading: Icon(Icons.book_outlined),
            title: const Text('Notebook'),
            selected: currentPage == 'notebook',
            onTap: () {
              if (currentPage != 'notebook') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotebookPage(
                        notebookRepo: notebookRepo!,
                        diaryRepo: diaryRepo!,
                        taskRepo: taskRepo!),
                  ),
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.settings_outlined),
            title: const Text('Setting'),
            selected: currentPage == 'setting',
            onTap: () {
              if (currentPage != 'setting') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SettingPage(
                            notebookRepo: notebookRepo,
                            diaryRepo: diaryRepo,
                            taskRepo: taskRepo,
                          )),
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.group_outlined),
            title: Text('Share with friends'),
          ),
          ListTile(
            leading: Icon(Icons.star_border_rounded),
            title: Text('Rate the app'),
          ),
          ListTile(
            leading: Icon(Icons.contact_support_outlined),
            title: Text('Contact the support team'),
          ),
        ],
      ),
    );
  }
}
