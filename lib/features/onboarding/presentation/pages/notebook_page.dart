import 'package:flutter/material.dart';
import 'package:the_notebook/features/diary/data/repositories/diary_repository.dart';
import 'package:the_notebook/features/diary/presentation/pages/diary.dart';
import 'package:the_notebook/features/onboarding/data/notebook_data.dart';
import 'package:the_notebook/features/onboarding/model/notebook.dart';
import 'package:the_notebook/features/onboarding/presentation/pages/notebook_form.dart';

class NotebookPage extends StatefulWidget {
  const NotebookPage({super.key, required this.repo});

  final DiaryRepository repo;

  @override
  State<NotebookPage> createState() => _NotebookPageState();
}

class _NotebookPageState extends State<NotebookPage> {
  void onAddNotebook() async{
    final newNotebook = await showModalBottomSheet<Notebook>(
      context: context,
      builder:(context) => const NotebookForm(),
    );
    if(newNotebook != null) {
      setState(() {
        notebookList.add(newNotebook);
      });
    }
  }

  void openDiary() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => DiaryPage(repo: widget.repo)));
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
        backgroundColor: const Color.fromARGB(255, 122, 171, 255),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("The Notebook", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),

            IconButton(
              onPressed: onAddNotebook,
              icon: Icon(Icons.add, color: Colors.white, size: 26),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: content
      ),
    );
  }
}

class NotebookTile extends StatelessWidget {
  final Notebook notebook;
  final VoidCallback openDiary;

  const NotebookTile({super.key, required this.notebook, required this.openDiary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade400, width: 1.0)
      ),
      child: ListTile(
        title: Text(notebook.title, style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: Icon(notebook.icon, size: 20),
        onTap: openDiary,
      ),
    );
  }
}
