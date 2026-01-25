import 'package:flutter/material.dart';
import 'package:the_notebook/core/models/notebook.dart';
import 'package:the_notebook/features/notebook/presentation/widgets/color_block.dart';
import 'package:the_notebook/features/notebook/presentation/widgets/form_button.dart';
import 'package:the_notebook/features/notebook/presentation/widgets/icon_picker.dart';

class NotebookForm extends StatefulWidget {
  final NotebookModel? notebook;
  final bool isEdited;

  const NotebookForm({super.key, this.notebook, required this.isEdited});

  @override
  State<NotebookForm> createState() => _NotebookFormState();
}

class _NotebookFormState extends State<NotebookForm> {
  final titleController = TextEditingController();
  String selectedIcon = home;
  Color selectedColor = Colors.transparent;

  final availableColors = [
    Colors.transparent,
    Colors.lightBlueAccent,
    Colors.lightGreenAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.redAccent,
    Colors.yellow[300]!,
    Colors.pinkAccent,
  ];

  final availableIcons = [
    home,
    work,
    travel,
    movie,
    food,
    gym,
    journal,
  ];

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
  void initState() {
    if (widget.isEdited) {
      titleController.text = widget.notebook!.title;
      selectedIcon = widget.notebook!.icon;
      selectedColor = widget.notebook!.color ?? Colors.transparent;
    }
    super.initState();
  }

  @override
  void dispose() {
    // Dispose the controlers
    titleController.dispose();
    super.dispose();
  }

  void onCreate() {
    if (!_formKey.currentState!.validate()) return;

    final title = titleController.text;

    NotebookModel newNotebook = NotebookModel(
        id: widget.notebook?.id,
        title: title,
        icon: selectedIcon,
        color: selectedColor);

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

  void onIconChange(icon) {
    setState(() {
      selectedIcon = icon;
    });
  }

  void onColorChanged(color) {
    setState(() {
      selectedColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.isEdited ? "Edit notebook" : "Add new notebook",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(onPressed: onClose, icon: Icon(Icons.cancel)),
              ],
            ),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: TextFormField(
                controller: titleController,
                maxLength: 25,
                decoration: inputDecoration,
                validator: (value) => validateTitle(value),
              ),
            ),
            Text("Icons", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            IconPicker(
                selectedIcon: selectedIcon,
                availableIcons: availableIcons,
                onIconChange: onIconChange),
            Text("Colors", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
            ColorBlock(
                selectedColor: selectedColor,
                availableColors: availableColors,
                onColorChange: onColorChanged),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  flex: 2,
                  child: FormButton(
                      textColor: Colors.white,
                      buttonText: widget.isEdited ? "Update" : "Add",
                      buttonColor: const Color.fromARGB(255, 122, 171, 255),
                      onPressed: onCreate),
                ),
                Expanded(
                  flex: 1,
                  child: FormButton(
                      textColor: Colors.black,
                      buttonText: "Cancel",
                      onPressed: onClose),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
