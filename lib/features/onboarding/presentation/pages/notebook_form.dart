import 'package:flutter/material.dart';
import 'package:the_notebook/features/onboarding/model/notebook.dart';

class NotebookForm extends StatefulWidget {
  const NotebookForm({super.key});

  @override
  State<NotebookForm> createState() => _NotebookFormState();
}

class _NotebookFormState extends State<NotebookForm> {
  final titleController = TextEditingController();
  NotebookType selectedCategory = NotebookType.life;

  InputDecoration inputDecoration = InputDecoration(
    hintText: "Enter title",
    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Color.fromARGB(255, 122, 171, 255),
        width: 1.5,
      ),
    ),
  );

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose the controlers
    titleController.dispose();
    super.dispose();
  }

  void onCreate() {
    if (!_formKey.currentState!.validate()) return;

    final title = titleController.text;

    Notebook newNotebook = Notebook(title: title, category: selectedCategory);

    Navigator.of(context).pop(newNotebook);
  }

  void onClose() {
    Navigator.pop(context);
  }

  String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a title.";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          spacing: 20,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Add new Notebook", style: TextStyle(fontSize: 20)),
                IconButton(onPressed: onClose, icon: Icon(Icons.cancel)),
              ],
            ),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: TextFormField(
                controller: titleController,
                maxLength: 20,
                decoration: inputDecoration,
                validator: (value) => validateTitle(value),
              ),
            ),
            DropdownButtonFormField<NotebookType>(
              initialValue: selectedCategory,
              items: NotebookType.values.map((category) {
                return DropdownMenuItem<NotebookType>(
                  value: category,
                  child: Text(
                    category.name.toUpperCase(),
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedCategory = value;
                  });
                }
              },
            ),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 122, 171, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: onCreate,
                    child: Text("Add", style: TextStyle(fontSize: 16)),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: onClose,
                    child: Text("Cancel", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
