import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:the_notebook/features/diary/data/repositories/diary_repository.dart';
import 'package:the_notebook/features/notebook/data/repository/notebook_repository.dart';
import 'package:the_notebook/features/onboarding/presentation/pages/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final diaryRepo = DiaryRepository();
  final notebookRepo = NotebookRepository();

  await diaryRepo.seedIfEmpty();

  // Develop on Web Browser
  runApp(DevicePreview(enabled: true, builder: (context) => MyApp(diaryRepository: diaryRepo, notebookRepository: notebookRepo)));

  // Develop on Simuator
  // runApp(MyApp(repo: repo));
}

class MyApp extends StatelessWidget {
  final DiaryRepository diaryRepository;
  final NotebookRepository notebookRepository;

  const MyApp({super.key, required this.diaryRepository, required this.notebookRepository});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Notebook',
      home: OnboardingScreen(diaryRepo: diaryRepository, notebookRepo: notebookRepository),
    );
  }
}
