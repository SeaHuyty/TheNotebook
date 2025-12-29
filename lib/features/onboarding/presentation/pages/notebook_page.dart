import 'package:flutter/material.dart';
import 'package:the_notebook/features/onboarding/model/notebook.dart';
import 'package:the_notebook/features/onboarding/presentation/pages/notebook_form.dart';

class NotebookPage extends StatefulWidget {
  const NotebookPage({super.key});

  @override
  State<NotebookPage> createState() => _NotebookPageState();
}

class _NotebookPageState extends State<NotebookPage> {
  void onAddNotebook() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return NotebookForm();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 122, 171, 255),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("The Notebook", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),

            IconButton(
              onPressed: onAddNotebook,
              icon: Icon(Icons.add, color: Colors.white, size: 25),
            ),
          ],
        ),
      ),
    );
  }
}
