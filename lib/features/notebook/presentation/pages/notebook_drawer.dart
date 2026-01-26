import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_notebook/core/providers/repository_providers.dart';
import 'package:the_notebook/features/diary/presentation/pages/diary.dart';
import 'package:the_notebook/core/models/notebook.dart';
import 'package:the_notebook/features/notebook/presentation/pages/notebook_form.dart';
import 'package:the_notebook/features/notebook/presentation/widgets/notebook_tile.dart';

class NotebookDrawer extends ConsumerStatefulWidget {
  const NotebookDrawer({super.key});

  @override
  ConsumerState<NotebookDrawer> createState() => _NotebookDrawerState();
}

class _NotebookDrawerState extends ConsumerState<NotebookDrawer> {
  List<NotebookModel> notebooks = [];
  bool isLoading = true;
  late final notebookRepo = ref.read(notebookRepositoryProvider);

  @override
  void initState() {
    super.initState();
    loadNotebooks();
  }

  Future<void> loadNotebooks() async {
    final data = await notebookRepo.getNotebooks();
    setState(() {
      notebooks = data;
      isLoading = false;
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
        notebooks.insert(
            notebooks.length,
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
        final index = notebooks.indexWhere((n) => n.id == updated.id);
        if (index != -1) {
          notebooks[index] = updated;
        }
      });
    }
  }

  void onDelete(NotebookModel notebook) async {
    final index = notebooks.indexOf(notebook);
    if (index == -1) return;

    try {
      await notebookRepo.deleteNotebook(notebook.id!);
      setState(() {
        notebooks.removeAt(index);
      });
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete notebook")),
        );
      }
    }
  }

  void openNotebook(int notebookId) {
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiaryPage(notebookId: notebookId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (notebooks.isNotEmpty) {
      content = ListView.builder(
        itemCount: notebooks.length,
        itemBuilder: (context, index) {
          final notebook = notebooks[index];
          return Column(
            children: [
              NotebookTile(
                notebook: notebook,
                openDiary: () => openNotebook(notebook.id!),
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

    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 10),
                const Text('Notebooks', style: TextStyle(fontSize: 20)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: onAddNotebook,
                ),
              ],
            ),
          ),
          Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : content),
        ],
      ),
    );
  }
}
