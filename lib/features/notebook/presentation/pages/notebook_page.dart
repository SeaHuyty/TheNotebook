import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_notebook/core/providers/repository_providers.dart';
import 'package:the_notebook/features/diary/presentation/pages/diary.dart';
import 'package:the_notebook/core/models/notebook.dart';
import 'package:the_notebook/features/notebook/presentation/pages/notebook_form.dart';
import 'package:the_notebook/features/notebook/presentation/widgets/notebook_tile.dart';
import 'package:the_notebook/shared/widgets/app_drawer.dart';

class NotebookPage extends ConsumerStatefulWidget {
  const NotebookPage({super.key});

  @override
  ConsumerState<NotebookPage> createState() => _NotebookPageState();
}

class _NotebookPageState extends ConsumerState<NotebookPage> {
  List<NotebookModel> notebookList = [];
  late final notebookRepo = ref.read(notebookRepositoryProvider);

  @override
  void initState() {
    super.initState();
    loadNotebooks();
  }

  Future<void> loadNotebooks() async {
    final notebooks = await notebookRepo.getNotebooks();
    setState(() {
      notebookList = notebooks;
    });
  }

  void onAddNotebook() async {
    final newNotebook = await Navigator.push<NotebookModel>(
      context,
      MaterialPageRoute(
        builder: (context) => const NotebookForm(isEdited: false),
      ),
    );

    if (newNotebook != null) {
      final newId = await notebookRepo.insertNotebook(newNotebook);
      setState(() {
        notebookList.insert(
            notebookList.length,
            NotebookModel(
                id: newId,
                title: newNotebook.title,
                icon: newNotebook.icon,
                color: newNotebook.color));
      });
    }
  }

  void onEdit(NotebookModel notebook) async {
    final updated = await Navigator.push<NotebookModel>(
      context,
      MaterialPageRoute(
        builder: (context) => NotebookForm(notebook: notebook, isEdited: true),
      ),
    );

    if (updated != null && updated.id != null) {
      await notebookRepo.updateNotebook(updated);
      setState(() {
        final index = notebookList.indexWhere((n) => n.id == updated.id);
        if (index != -1) {
          notebookList[index] = updated;
        }
      });
    }
  }

  void onDelete(NotebookModel notebook) async {
    final index = notebookList.indexOf(notebook);
    if (index == -1) return;

    try {
      await notebookRepo.deleteNotebook(notebook.id!);
      setState(() {
        notebookList.removeAt(index);
      });
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete notebook")),
        );
      }
    }
  }

  void openDiary(int notebookId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DiaryPage(notebookId: notebookId)));
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
                openDiary: () => openDiary(notebook.id!),
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
      drawer: AppDrawer(
        currentPage: 'notebook',
      ),
      body: Padding(padding: EdgeInsets.all(20), child: content),
    );
  }
}
