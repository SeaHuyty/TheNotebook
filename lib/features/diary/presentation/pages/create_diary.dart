import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:the_notebook/features/diary/domain/diary.dart' as domain;
import 'package:the_notebook/features/diary/domain/diary_image.dart' as domain;
import 'package:the_notebook/features/diary/data/repositories/diary_repository.dart';
import 'package:the_notebook/features/diary/presentation/widgets/image_widget.dart';
import 'package:universal_io/universal_io.dart';

class CreateDiaryPage extends StatefulWidget {
  final DiaryRepository repo;

  const CreateDiaryPage({super.key, required this.repo});

  @override
  State<CreateDiaryPage> createState() => _CreateDiaryPageState();
}

class _CreateDiaryPageState extends State<CreateDiaryPage> {
  // Inputs
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  DateTime selectedDate = DateTime.now();
  XFile? selectedImage;
  bool? isLandscape;

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
      final bytes = await image.readAsBytes();

      // Correct way to decode image
      final ui.Codec codec = await ui.instantiateImageCodec(bytes);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      final decodedImage = frameInfo.image;
      final orientation = decodedImage.width > decodedImage.height;

      setState(() {
        selectedImage = image;
        isLandscape = orientation;
      });
    }
  }

  Future<String?> saveImagePermanently(XFile image) async {
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final Directory imageDir = Directory('${appDocDir.path}/diary_images');
      if (!await imageDir.exists()) {
        await imageDir.create(recursive: true);
      }

      final String fileName =
          '${DateTime.now().microsecondsSinceEpoch}${path.extension(image.path)}';
      final String newPath = '${imageDir.path}/$fileName';

      final File sourceFile = File(image.path);
      await sourceFile.copy(newPath);

      return newPath;
    } catch (e) {
      return null;
    }
  }

  Future<void> createDiary() async {
    String? imagePath;

    if (selectedImage != null) {
      imagePath = await saveImagePermanently(selectedImage!);

      // For web testing
      imagePath ??= selectedImage!.path;
    }

    final diary = domain.Diary(
        date: selectedDate, content: descriptionController.text, image: domain.DiaryImage(imagePath: imagePath!, isLandscape: isLandscape!));

    await widget.repo.insertDiary(diary);
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
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
            child:
                TextButton(onPressed: createDiary, child: const Text('Save')),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 8,
            ),
            TextButton(
              onPressed: () => selectDate(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              child: Row(
                spacing: 10,
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 20,
                  ),
                  Text(
                    selectedDate.toString().split(' ')[0],
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: titleController,
              style: const TextStyle(fontSize: 24),
              decoration:
                  InputDecoration(hintText: 'Title', border: InputBorder.none),
            ),
            const SizedBox(
              height: 4,
            ),
            SizedBox(
              height: 180,
              child: TextFormField(
                controller: descriptionController,
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    hintText: 'What is on your mind?',
                    border: InputBorder.none),
              ),
            ),
            const SizedBox(height: 10),
            if (selectedImage != null && isLandscape != null)
              Center(
                child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(15),
                    child: ImageWidget(
                        image: domain.DiaryImage(
                      imagePath: selectedImage!.path,
                      isLandscape: isLandscape!,
                    ))),
              ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: pickImage,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 233, 226, 226),
                  foregroundColor: Colors.black,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(8))),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    const Icon(
                      Icons.image_outlined,
                      size: 19,
                    ),
                    Text(
                      selectedImage != null ? 'Change image' : 'Add image',
                      style: const TextStyle(fontSize: 17),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
