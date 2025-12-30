import 'package:flutter/material.dart';
import 'package:the_notebook/features/diary/data/repositories/diary_repository.dart';
import 'package:the_notebook/features/diary/presentation/pages/diary.dart';
import 'package:the_notebook/features/onboarding/data/notebook_data.dart';
import 'package:the_notebook/features/onboarding/model/notebook.dart';
import 'package:the_notebook/features/onboarding/presentation/pages/notebook_form.dart';
import 'package:the_notebook/features/onboarding/presentation/widgets/notebook_tile.dart';
import 'package:the_notebook/shared/widgets/app_drawer.dart';

class NotebookPage extends StatefulWidget {
  const NotebookPage({super.key, required this.repo});

  final DiaryRepository repo;

  @override
  State<NotebookPage> createState() => _NotebookPageState();
}

class _NotebookPageState extends State<NotebookPage> {
  void onAddNotebook() async {
    final newNotebook = await showModalBottomSheet<Notebook>(
      context: context,
      builder: (context) => const NotebookForm(),
    );
    if (newNotebook != null) {
      setState(() {
        notebookList.add(newNotebook);
      });
    }
  }

  void openDiary() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DiaryPage(repo: widget.repo)));
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (notebookList.isNotEmpty) {
      content = ListView.builder(
        itemCount: notebookList.length,
        itemBuilder: (context, index) {
          final notebook = notebookList[index];
          return NotebookTile(
            notebook: notebook,
            openDiary: () => openDiary(),
          );
        },
      );
    } else {
      content = Center(
        child: Text(
          "Click + button to add your notebook.",
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.menu_rounded),
          );
        }),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("The Notebook"),
            IconButton(
              onPressed: onAddNotebook,
              icon: Icon(Icons.add, size: 26),
            ),
          ],
        ),
      ),
      drawer: AppDrawer(currentPage: 'notebook'),
      body: Padding(padding: EdgeInsets.all(20), child: content),
    );
  }
}