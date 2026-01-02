import 'package:flutter/material.dart';
import 'package:the_notebook/features/notebook/model/notebook.dart';

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
                    "Are you sure you want to delete this notebook?"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text("Cancel",
                          style: TextStyle(color: Colors.black))),
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child:
                          Text("Delete", style: TextStyle(color: Colors.red))),
                ],
              );
            });
        return confirm;
      },
      onDismissed: (direction) => onDismissed(),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: notebook.color,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade400, width: 1.0)),
        child: ListTile(
          title: Text(notebook.title,
              style: TextStyle(fontWeight: FontWeight.bold)),
          leading: Container(
            width: 40,
            height: 40,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: notebook.getSecondaryColor(notebook.color),
            ),
            child: Image.asset(notebook.icon, fit: BoxFit.cover),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 18),
          onTap: openDiary,
          onLongPress: onEdit,
        ),
      ),
    );
  }
}
