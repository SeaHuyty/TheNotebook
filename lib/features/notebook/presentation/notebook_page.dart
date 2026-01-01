import 'package:flutter/material.dart';
import 'package:the_notebook/features/diary/data/repositories/diary_repository.dart';
import 'package:the_notebook/features/diary/presentation/pages/diary.dart';
import 'package:the_notebook/features/notebook/data/repository/notebook_repository.dart';
import 'package:the_notebook/features/notebook/model/notebook.dart';
import 'package:the_notebook/features/notebook/presentation/notebook_form.dart';
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
                category: newNotebook.category));
      });
    }
  }

  void onEdit(Notebook notebook) async {
    final updated = await showModalBottomSheet<Notebook>(
      context: context,
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

    final removedNotebook = notebookList[index];

    setState(() {
      notebookList.removeAt(index);
    });
    
    try {
      await widget.notebookRepo.deleteNotebook(notebook.id!);
    } catch (error) {
      setState(() {
        notebookList.insert(index, removedNotebook);
      });
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

class NotebookTile extends StatelessWidget {
  final Notebook notebook;
  final VoidCallback openDiary;
  final VoidCallback onDismissed;
  final VoidCallback onEdit;

  const NotebookTile(
      {super.key,
      required this.notebook,
      required this.openDiary,
      required this.onDismissed,
      required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(notebook.id),
      direction: DismissDirection.horizontal,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.delete, color: Colors.red),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.red),
      ),
      confirmDismiss: (direction) async {
        final bool? confirm = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Delete Notebook"),
                content: const Text(
                    "Are you sure you want to delete this notebook? This action cannot be undone"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text("Cancel")),
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text("Okay")),
                ],
              );
            });
        return confirm;
      },
      onDismissed: (direction) => onDismissed(),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade400, width: 1.0)),
        child: ListTile(
          title: Text(notebook.title,
              style: TextStyle(fontWeight: FontWeight.bold)),
          trailing: Icon(notebook.icon, size: 20),
          onTap: openDiary,
          onLongPress: onEdit,
        ),
      ),
    );
  }
}
