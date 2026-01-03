import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:the_notebook/features/diary/data/repositories/diary_repository.dart';
import 'package:the_notebook/features/diary/data/repositories/task_repository.dart';
import 'package:the_notebook/features/diary/domain/diary.dart' as domain;
import 'package:the_notebook/features/diary/domain/diary_image.dart' as domain;
import 'package:the_notebook/features/diary/domain/task.dart';
import 'package:the_notebook/features/diary/presentation/widgets/image_widget.dart';
import 'package:universal_io/universal_io.dart';

class EditDiaryPage extends StatefulWidget {
  final domain.Diary diary;
  final DiaryRepository diaryRepository;
  final TaskRepository taskRepository;

  const EditDiaryPage(
      {super.key,
      required this.diary,
      required this.diaryRepository,
      required this.taskRepository});

  @override
  State<EditDiaryPage> createState() => _EditDiaryPageState();
}

class _EditDiaryPageState extends State<EditDiaryPage> {
  // Inputs
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  late DateTime selectedDate;
  XFile? selectedImage;
  bool? isLandscape;

  List<Task> tasks = [];

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

  Future<void> onEdit() async {
    String? imagePath;
    // Flag
    late bool contentChanged =
        descriptionController.text != widget.diary.content;
    late bool dateChanged = selectedDate != widget.diary.date;
    late bool imageChanged = (selectedImage != null &&
            selectedImage!.path != widget.diary.image?.imagePath) ||
        (selectedImage == null && widget.diary.image != null);

    if (selectedImage != null) {
      imagePath = await saveImagePermanently(selectedImage!);

      // For web testing
      imagePath ??= selectedImage!.path;
    }

    final diary = domain.Diary(
        notebookId: widget.diary.notebookId,
        id: widget.diary.id,
        date: selectedDate,
        content: descriptionController.text,
        image: selectedImage != null && imagePath != null && isLandscape != null
            ? domain.DiaryImage(imagePath: imagePath, isLandscape: isLandscape!)
            : null);

    await widget.diaryRepository.updateDiary(diary,
        contentChanged: contentChanged,
        dateChanged: dateChanged,
        imageChanged: imageChanged);

    // Update tasks
    for (var task in tasks) {
      if (task.id != null) {
        await widget.taskRepository.updateTask(task);
        // Update subtasks
        if (task.subtasks != null) {
          for (var subtask in task.subtasks!) {
            if (subtask.id != null) {
              await widget.taskRepository.updateTask(subtask);
            }
          }
        }
      }
    }

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  void initState() {
    super.initState();
    descriptionController.text = widget.diary.content;
    titleController.text = 'A Productive Title';
    selectedDate = widget.diary.date;
    tasks = widget.diary.tasks ?? [];

    if (widget.diary.image != null) {
      selectedImage = XFile(widget.diary.image!.imagePath);
      isLandscape = widget.diary.image!.isLandscape;
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
            child: TextButton(onPressed: onEdit, child: const Text('Save')),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
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
                textAlignVertical: TextAlignVertical.top,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    hintText: 'What is on your mind?',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
            ),
            const SizedBox(height: 10),
            if (tasks.isNotEmpty) ...[
              const Text(
                'Tasks',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...tasks.asMap().entries.map((entry) {
                int index = entry.key;
                Task task = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: TextEditingController(text: task.title)
                            ..selection = TextSelection.fromPosition(
                                TextPosition(offset: task.title.length)),
                          decoration: const InputDecoration(
                            labelText: 'Task title',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              tasks[index] = Task(
                                id: task.id,
                                title: value,
                                isCompleted: task.isCompleted,
                                subtasks: task.subtasks,
                              );
                            });
                          },
                        ),
                        if (task.subtasks != null &&
                            task.subtasks!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          const Text('Subtasks:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          ...task.subtasks!.asMap().entries.map((subEntry) {
                            int subIndex = subEntry.key;
                            Task subtask = subEntry.value;
                            return Padding(
                              padding: const EdgeInsets.only(left: 16, top: 4),
                              child: TextField(
                                controller:
                                    TextEditingController(text: subtask.title)
                                      ..selection = TextSelection.fromPosition(
                                          TextPosition(
                                              offset: subtask.title.length)),
                                decoration: const InputDecoration(
                                  labelText: 'Subtask title',
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                                onChanged: (value) {
                                  final updatedSubtasks = [...task.subtasks!];
                                  updatedSubtasks[subIndex] = Task(
                                    id: subtask.id,
                                    title: value,
                                    isCompleted: subtask.isCompleted,
                                    parentTaskId: subtask.parentTaskId,
                                  );
                                  tasks[index] = Task(
                                    id: task.id,
                                    title: task.title,
                                    isCompleted: task.isCompleted,
                                    subtasks: updatedSubtasks,
                                  );
                                },
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 10),
            ],
            if (selectedImage != null && isLandscape != null)
              Center(
                child: SizedBox(
                  height: isLandscape! ? 180 : null,
                  child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(15),
                      child: ImageWidget(
                          image: domain.DiaryImage(
                        imagePath: selectedImage!.path,
                        isLandscape: isLandscape!,
                      ))),
                ),
              ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: pickImage,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 233, 226, 226),
                  foregroundColor: Colors.black,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
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
