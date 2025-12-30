import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:the_notebook/features/diary/data/repositories/diary_repository.dart';
import 'package:the_notebook/features/onboarding/presentation/pages/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final repo = DiaryRepository();

  await repo.seedIfEmpty();

  // Develop on Web Browser
  runApp(DevicePreview(enabled: true, builder: (context) => MyApp(repo: repo)));

  // Develop on Simuator
  // runApp(MyApp(repo: repo));
}

class MyApp extends StatelessWidget {
  final DiaryRepository repo;

  const MyApp({super.key, required this.repo});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Notebook',
      home: OnboardingScreen(repo: repo),
    );
  }
}
