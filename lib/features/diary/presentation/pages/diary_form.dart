import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:the_notebook/core/models/diary.dart';
import 'package:the_notebook/core/models/diary_image.dart';
import 'package:the_notebook/core/models/tag.dart';
import 'package:the_notebook/core/models/task.dart';
import 'package:the_notebook/features/diary/data/repositories/diary_repository.dart';
import 'package:the_notebook/features/diary/data/repositories/diary_tag_repository.dart';
import 'package:the_notebook/features/diary/data/repositories/task_repository.dart';
import 'package:the_notebook/features/diary/presentation/widgets/image_gallery.dart';
import 'package:the_notebook/features/diary/presentation/widgets/label_chip.dart';
import 'package:the_notebook/features/diary/presentation/widgets/tag_drawer.dart';
import 'package:universal_io/universal_io.dart';

class DiaryFormPage extends ConsumerStatefulWidget {
  final int? notebookId; // For create mode
  final DiaryModel? diary; // For edit mode

  const DiaryFormPage({
    super.key,
    this.notebookId,
    this.diary,
  }) : assert(notebookId != null || diary != null,
            'Either notebookId or diary must be provided');

  @override
  ConsumerState<DiaryFormPage> createState() => _DiaryFormPageState();
}

class _DiaryFormPageState extends ConsumerState<DiaryFormPage> {
  // Repository
  late final diaryRepository = ref.read(diaryRepositoryProvider);
  late final taskRepository = ref.read(taskRepositoryProvider);

  // Inputs
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController taskController = TextEditingController();
  final TextEditingController subtaskController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  List<XFile> selectedImages = [];
  List<bool> isLandscape = [];
  List<TagModel> tags = [];

  TaskModel? mainTask;
  List<TaskModel> subtasks = [];

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
      tags = widget.diary!.tags ?? [];

      if (widget.diary!.images != null && widget.diary!.images!.isNotEmpty) {
        selectedImages =
            widget.diary!.images!.map((img) => XFile(img.imagePath)).toList();
        isLandscape =
            widget.diary!.images!.map((img) => img.isLandscape).toList();
      }

      if (widget.diary!.tasks != null && widget.diary!.tasks!.isNotEmpty) {
        mainTask = widget.diary!.tasks!.first;
        subtasks = List.from(mainTask!.subtasks ?? []);
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
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      List<bool> orientations = [];

      for (var image in images) {
        final bytes = await image.readAsBytes();

        final ui.Codec codec = await ui.instantiateImageCodec(bytes);
        final ui.FrameInfo frameInfo = await codec.getNextFrame();
        final decodedImage = frameInfo.image;
        final orientation = decodedImage.width > decodedImage.height;

        orientations.add(orientation);
      }

      setState(() {
        selectedImages.addAll(images);
        isLandscape.addAll(orientations);
      });
    }
  }

  Future<List<DiaryImageModel>?> diaryImages() async {
    if (selectedImages.isNotEmpty) {
      final List<DiaryImageModel> images = [];
      for (var entry in selectedImages.asMap().entries) {
        final index = entry.key;
        final image = entry.value;
        images.add(DiaryImageModel(
            imagePath: await saveImagePermanently(image),
            isLandscape: isLandscape[index]));
      }

      return images;
    } else {
      return null;
    }
  }

  Future<String> saveImagePermanently(XFile image) async {
    try {
      if (kIsWeb) {
        return image.path;
      }

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
      return image.path;
    }
  }

  Future<void> createDiary() async {
    // Assign subtasks to main task if it exists
    if (mainTask != null) {
      mainTask = TaskModel(
        title: mainTask!.title,
        isCompleted: false,
        subtasks: subtasks,
      );
    }

    final diary = DiaryModel(
        id: isEditMode ? widget.diary!.id : null,
        notebookId: isEditMode ? widget.diary!.notebookId : widget.notebookId!,
        date: selectedDate,
        time: selectedTime,
        title: titleController.text,
        content: descriptionController.text,
        tasks: mainTask != null ? [mainTask!] : null,
        images: await diaryImages());

    if (isEditMode) {
      // Check if tasks changed
      bool tasksChanged = false;
      final oldTasks = widget.diary!.tasks;
      if ((oldTasks == null || oldTasks.isEmpty) && mainTask != null) {
        tasksChanged = true;
      } else if ((oldTasks != null && oldTasks.isNotEmpty) &&
          mainTask == null) {
        tasksChanged = true;
      } else if (oldTasks != null && oldTasks.isNotEmpty && mainTask != null) {
        final oldMainTask = oldTasks.first;
        final oldSubtasks = oldMainTask.subtasks ?? [];
        if (oldMainTask.title != mainTask!.title ||
            oldSubtasks.length != subtasks.length) {
          tasksChanged = true;
        } else {
          // Only compare if lengths are equal
          for (int i = 0; i < subtasks.length; i++) {
            if (subtasks[i].title != oldSubtasks[i].title) {
              tasksChanged = true;
              break;
            }
          }
        }
      }

      // Update existing diary
      await diaryRepository.updateDiary(
        diary,
        contentChanged: descriptionController.text != widget.diary!.content,
        dateChanged: selectedDate != widget.diary!.date,
        imageChanged:
            selectedImages.length != (widget.diary!.images?.length ?? 0),
        timeChanged: selectedTime != widget.diary!.time,
        taskChanged: tasksChanged,
      );
    } else {
      // Create new diary
      final diaryId = await diaryRepository.insertDiary(diary);

      final diaryTagRepo = ref.read(diaryTagRepositoryProvider);
      for (var tag in tags) {
        if (tag.id != null) {
          await diaryTagRepo.insertTagToDiary(tag.id!, diaryId);
        }
      }
    }

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
          Row(
            spacing: 5,
            children: [
              OutlinedButton(
                  onPressed: createDiary,
                  child: Row(
                    spacing: 5,
                    children: [const Icon(Icons.check), Text('Done')],
                  )),
              Builder(builder: (context) {
                return IconButton(
                    onPressed: Scaffold.of(context).openEndDrawer,
                    icon: const Icon(Icons.sell_outlined));
              }),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz))
            ],
          ),
        ],
      ),
      endDrawer: TagDrawer(
        diaryId: widget.diary?.id,
        tags: tags,
        onTagsChanged: (updateTags) {
          setState(() {
            tags = updateTags;
          });
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 20,
                    ),
                    Text(
                      DateFormat('MMMM, dd, yyyy').format(selectedDate),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 5,
                  children: [
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
                          children: [
                            LabelChip(
                              icon: Icon(
                                Icons.access_time,
                                size: 18,
                              ),
                              time: selectedTime,
                            ),
                          ],
                        )),
                    if (tags.isNotEmpty)
                      for (var tag in tags) ...[
                        LabelChip(
                          icon: Icon(
                            Icons.tag,
                            size: 18,
                          ),
                          tag: tag.name,
                        ),
                      ],
                    if (isEditMode)
                      LabelChip(
                        icon: Icon(
                          Icons.fiber_manual_record_outlined,
                          size: 18,
                        ),
                        date: widget.diary!.date,
                      ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
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
                          mainTask = TaskModel(
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
                Row(
                  children: [
                    Expanded(
                      child: Text('Main Task: ${mainTask!.title}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        size: 20,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          mainTask = null;
                          subtasks.clear();
                        });
                      },
                      tooltip: 'Delete main task',
                    ),
                  ],
                ),
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
                          subtasks.add(TaskModel(
                              title: subtaskController.text,
                              isCompleted: false));
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
                      ...subtasks.asMap().entries.map((entry) {
                        final index = entry.key;
                        final subtask = entry.value;
                        return Row(
                          children: [
                            Expanded(child: Text('- ${subtask.title}')),
                            IconButton(
                              icon: const Icon(Icons.close, size: 18),
                              onPressed: () {
                                setState(() {
                                  subtasks.removeAt(index);
                                });
                              },
                              tooltip: 'Remove subtask',
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
              ],
              const SizedBox(height: 10),
              if (selectedImages.isNotEmpty)
                ImageGalleryWidget(
                  images: selectedImages,
                  isLandscape: isLandscape,
                  showRemoveButton: true,
                  onRemove: (index) {
                    setState(() {
                      selectedImages.removeAt(index);
                      isLandscape.removeAt(index);
                    });
                  },
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
                        selectedImages.isEmpty ? 'Add image' : 'Add more image',
                        style: const TextStyle(fontSize: 17),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
