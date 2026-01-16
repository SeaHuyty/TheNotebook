import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_notebook/core/providers/repository_providers.dart';
import 'package:the_notebook/features/diary/presentation/pages/diary.dart';
import 'package:the_notebook/features/notebook/model/notebook.dart';

class NotebookDrawer extends ConsumerStatefulWidget {
  const NotebookDrawer({super.key});

  @override
  ConsumerState<NotebookDrawer> createState() => _NotebookDrawerState();
}

class _NotebookDrawerState extends ConsumerState<NotebookDrawer> {
  List<Notebook> notebooks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadNotebooks();
  }

  Future<void> loadNotebooks() async {
    final notebookRepo = ref.read(notebookRepositoryProvider);
    final data = await notebookRepo.getNotebooks();
    setState(() {
      notebooks = data;
      isLoading = false;
    });
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
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: notebooks.length,
                    itemBuilder: (context, index) {
                      final notebook = notebooks[index];
                      return ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: notebook.color != null
                                ? notebook.getSecondaryColor(notebook.color)
                                : Colors.grey[200],
                          ),
                          child: Image.asset(notebook.icon, fit: BoxFit.cover),
                        ),
                        title: Text(notebook.title),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => openNotebook(notebook.id!),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}