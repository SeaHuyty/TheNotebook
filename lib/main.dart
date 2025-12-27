import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:isar/isar.dart';
import 'package:minimal_diary/features/diary/data/repositories/diary_repository.dart';
import 'package:minimal_diary/features/diary/domain/diary.dart';
import 'package:path_provider/path_provider.dart';
import 'features/onboarding/presentation/pages/onboarding_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([DiarySchema], directory: dir.path);
  final repo = DiaryRepository(isar);

  await repo.seedIfEmpty();

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MyApp(repo: repo),
    ),
  );
}

class MyApp extends StatelessWidget {
  final DiaryRepository repo;

  const MyApp({super.key, required this.repo});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TheNotebook',
      home: OnboardingPage(repo: repo),
    );
  }
}