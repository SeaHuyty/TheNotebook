import 'package:flutter/material.dart';
import 'package:the_notebook/features/diary/data/repositories/diary_repository.dart';
import 'package:the_notebook/features/onboarding/presentation/pages/notebook_page.dart';
import '../../features/diary/presentation/pages/diary.dart';

class AppDrawer extends StatelessWidget {
  final DiaryRepository? repo;
  final String currentPage;

  const AppDrawer({super.key, required this.currentPage, this.repo});

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
            title: const Text('Notebook'),
            selected: currentPage == 'notebook',
            onTap: () {
              if (currentPage != 'notebook') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotebookPage(repo: repo!),
                  ),
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(title: const Text('Setting')),
        ],
      ),
    );
  }
}
