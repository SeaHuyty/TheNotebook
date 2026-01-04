import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:the_notebook/features/diary/data/repositories/task_repository.dart';
import 'package:the_notebook/features/diary/domain/diary.dart' as domain;
import 'package:the_notebook/features/diary/domain/diary_image.dart' as domain;
import 'package:the_notebook/features/diary/data/repositories/diary_repository.dart';
import 'package:the_notebook/features/diary/domain/task.dart';
import 'package:the_notebook/features/diary/presentation/widgets/image_widget.dart';
import 'package:universal_io/universal_io.dart';

class DiaryFormPage extends StatefulWidget {
  final DiaryRepository diaryRepository;
  final TaskRepository taskRepository;
  final int? notebookId; // For create mode
  final domain.Diary? diary; // For edit mode

  const DiaryFormPage({
    super.key,
    required this.diaryRepository,
    required this.taskRepository,
    this.notebookId,
    this.diary,
  }) : assert(notebookId != null || diary != null,
            'Either notebookId or diary must be provided');

  @override
  State<DiaryFormPage> createState() => _DiaryFormPageState();
}

class _DiaryFormPageState extends State<DiaryFormPage> {
  // Inputs
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController taskController = TextEditingController();
  final TextEditingController subtaskController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  XFile? selectedImage;
  bool? isLandscape;

  Task? mainTask;
  List<Task> subtasks = [];

  bool get isEditMode => widget.diary != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      // Edit mode - populate with existing data
      descriptionController.text = widget.diary!.content ?? '';
      titleController.text = widget.diary!.title;
      selectedDate = widget.diary!.date;
      selectedTime = widget.diary!.time;

      if (widget.diary!.image != null) {
        selectedImage = XFile(widget.diary!.image!.imagePath);
        isLandscape = widget.diary!.image!.isLandscape;
      }

      if (widget.diary!.tasks != null && widget.diary!.tasks!.isNotEmpty) {
        mainTask = widget.diary!.tasks!.first;
        subtasks = mainTask!.subtasks ?? [];
      }
    } else {
      // Create mode - use defaults
      selectedDate = DateTime.now();
      selectedTime = TimeOfDay.now();
    }
  }

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
    // Assign subtasks to main task if it exists
    if (mainTask != null) {
      mainTask = Task(
        title: mainTask!.title,
        isCompleted: false,
        subtasks: subtasks,
      );
    }

    String? imagePath;

    if (selectedImage != null) {
      imagePath = await saveImagePermanently(selectedImage!);
      imagePath ??= selectedImage!.path; // For web testing
    }

    final diary = domain.Diary(
      id: isEditMode ? widget.diary!.id : null,
      notebookId: isEditMode ? widget.diary!.notebookId : widget.notebookId!,
      date: selectedDate,
      title: titleController.text,
      content: descriptionController.text,
      tasks: mainTask != null ? [mainTask!] : null,
      image: selectedImage != null && imagePath != null && isLandscape != null
          ? domain.DiaryImage(
              imagePath: imagePath,
              isLandscape: isLandscape!,
            )
          : null,
    );

    if (isEditMode) {
      // Update existing diary
      await widget.diaryRepository.updateDiary(
        diary,
        contentChanged: descriptionController.text != widget.diary!.content,
        dateChanged: selectedDate != widget.diary!.date,
        imageChanged: selectedImage?.path != widget.diary!.image?.imagePath,
      );
    } else {
      // Create new diary
      final diaryId = await widget.diaryRepository.insertDiary(diary);

      for (var sub in subtasks) {
        await widget.taskRepository.insertTask(sub, diaryId);
      }
    }

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  String _formatTime(TimeOfDay time, BuildContext context) {
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    return DateFormat.jm().format(dateTime); // e.g. 5:30 PM
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
          Row(
            spacing: 5,
            children: [
              OutlinedButton(
                  onPressed: saveDiary,
                  child: Row(
                    spacing: 5,
                    children: [
                      const Icon(Icons.check),
                      Text(isEditMode ? 'Save' : 'Done')
                    ],
                  )),
              IconButton(onPressed: () {}, icon: const Icon(Icons.sell_outlined)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz))
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () => selectDate(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                padding: EdgeInsets.zero,
              ),
              child: Row(
                spacing: 10,
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                  ),
                  Text(
                    DateFormat('MMMM, dd, yyyy').format(selectedDate),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            TextButton(
                onPressed: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
                      context: context, initialTime: selectedTime);
                  if (pickedTime != null) {
                    setState(() {
                      selectedTime = pickedTime;
                    });
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Row(
                  spacing: 5,
                  children: [
                    const Icon(Icons.access_time),
                    Text(_formatTime(selectedTime, context))
                  ],
                )),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: titleController,
              style: const TextStyle(fontSize: 24),
              decoration: const InputDecoration(
                  hintText: 'Title', border: InputBorder.none),
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
                decoration: const InputDecoration(
                    hintText: 'What is on your mind?',
                    border: InputBorder.none),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Task",
              style: TextStyle(fontSize: 20),
            ),
            if (mainTask == null) ...[
              TextField(
                controller: taskController,
                decoration: InputDecoration(
                  hintText: 'Enter main task title',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (taskController.text.isEmpty) return;
                      setState(() {
                        mainTask = Task(
                            title: taskController.text, isCompleted: false);
                        taskController.clear();
                      });
                    },
                  ),
                ),
              ),
            ],

            // Subtask Input
            if (mainTask != null) ...[
              const SizedBox(height: 16),
              Text('Main Task: ${mainTask!.title}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: subtaskController,
                decoration: InputDecoration(
                  hintText: 'Add a subtask',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (subtaskController.text.isEmpty) return;
                      setState(() {
                        subtasks.add(Task(
                            title: subtaskController.text, isCompleted: false));
                        subtaskController.clear();
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (subtasks.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Subtasks:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    ...subtasks.map((s) => Text('- ${s.title}')),
                  ],
                ),
            ],
            const SizedBox(height: 10),
            if (selectedImage != null && isLandscape != null)
              Center(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
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