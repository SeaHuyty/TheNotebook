import 'package:flutter/material.dart';
import 'package:the_notebook/features/diary/data/repositories/diary_repository.dart';
import 'package:the_notebook/features/diary/presentation/pages/diary.dart';
import 'package:the_notebook/features/notebook/data/repository/notebook_repository.dart';
import 'package:the_notebook/features/notebook/model/notebook.dart';
import 'package:the_notebook/features/notebook/presentation/notebook_form.dart';
import 'package:the_notebook/features/notebook/widgets/notebook_tile.dart';
import 'package:the_notebook/shared/widgets/app_drawer.dart';

class NotebookPage extends StatefulWidget {
  const NotebookPage(
      {super.key, required this.notebookRepo, required this.diaryRepo});

  final NotebookRepository notebookRepo;
  final DiaryRepository diaryRepo;

  @override
  State<NotebookPage> createState() => _NotebookPageState();
}

class _NotebookPageState extends State<NotebookPage> {
  List<Notebook> notebookList = [];

  @override
  void initState() {
    super.initState();
    loadNotebooks();
  }

  Future<void> loadNotebooks() async {
    final notebooks = await widget.notebookRepo.getNotebooks();
    setState(() {
      notebookList = notebooks;
    });
  }

  void onAddNotebook() async {
    final newNotebook = await showModalBottomSheet<Notebook>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const NotebookForm(isEdited: false),
    );
    if (newNotebook != null) {
      final newId = await widget.notebookRepo.insertNotebook(newNotebook);
      setState(() {
        notebookList.insert(
            notebookList.length,
            Notebook(
                id: newId,
                title: newNotebook.title,
                icon: newNotebook.icon,
                color: newNotebook.color));
      });
    }
  }

  void onEdit(Notebook notebook) async {
    final updated = await showModalBottomSheet<Notebook>(
      context: context,
      isScrollControlled: true,
      builder: (context) => NotebookForm(notebook: notebook, isEdited: true),
    );
    if (updated != null && updated.id != null) {
      await widget.notebookRepo.updateNotebook(updated);
      setState(() {
        final index = notebookList.indexWhere((n) => n.id == updated.id);
        if (index != -1) {
          notebookList[index] = updated;
        }
      });
    }
  }

  void onDelete(Notebook notebook) async {
    final index = notebookList.indexOf(notebook);
    if (index == -1) return;

    try {
      await widget.notebookRepo.deleteNotebook(notebook.id!);
      setState(() {
        notebookList.removeAt(index);
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete notebook")),
      );
    }
  }

  void openDiary() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DiaryPage(repo: widget.diaryRepo)));
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (notebookList.isNotEmpty) {
      content = ListView.builder(
        itemCount: notebookList.length,
        itemBuilder: (context, index) {
          final notebook = notebookList[index];
          return Column(
            children: [
              NotebookTile(
                notebook: notebook,
                openDiary: () => openDiary(),
                onDismissed: () => onDelete(notebook),
                onEdit: () => onEdit(notebook),
              ),
              SizedBox(height: 15)
            ],
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