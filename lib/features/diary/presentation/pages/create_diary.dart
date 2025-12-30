import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_notebook/features/diary/domain/diary.dart' as domain;
import 'package:the_notebook/features/diary/data/repositories/diary_repository.dart';

class CreateDiary extends StatefulWidget {
  final DiaryRepository repo;

  const CreateDiary({super.key, required this.repo});

  @override
  State<CreateDiary> createState() => _CreateDiaryState();
}

class _CreateDiaryState extends State<CreateDiary> {
  // Inputs
  final TextEditingController contentController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  DateTime selectedDate = DateTime.now();
  XFile? selectedImage;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime(DateTime.now().year + 5, 12, 31),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  void createDiary() {
    final diary = domain.Diary(date: selectedDate, content: contentController.text, imageUrl: selectedImage!.path);

    widget.repo.insertDiary(diary);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(
            builder: (context) {
              return IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios, size: 20),
              );
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(onPressed: createDiary, child: const Text('Save')),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(8),
        child: Column(
          children: [
            TextFormField(
              controller: contentController,
              decoration: InputDecoration(hintText: 'Content'),
            ),
            TextButton(
              onPressed: () => selectDate(context),
              child: Text(selectedDate.toString().split(' ')[0]),
            ),
            const SizedBox(height: 10),
            if (selectedImage != null) Image.network(selectedImage!.path, height: 200),
            ElevatedButton.icon(
              onPressed: pickImage,
              icon: Icon(Icons.image),
              label: const Text('Add Image'),
            ),
          ],
        ),
      ),
    );
  }
}
