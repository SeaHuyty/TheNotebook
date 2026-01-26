import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_notebook/core/database/seed/seed_index.dart';
import 'package:the_notebook/core/providers/theme_provider.dart';
import 'package:the_notebook/features/diary/presentation/pages/diary.dart';
import 'package:the_notebook/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:the_notebook/features/setting/data/repositories/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final seedRepo = SeedIndex();

  await seedRepo.seedIfEmpty();

  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late final userRepo = ref.read(userRepositoryProvider);
  late int? defaultNotebook;

  @override
  void initState() {
    loadDefaultNotebook();
    super.initState();
  }

  void loadDefaultNotebook() async {
    defaultNotebook = await userRepo.getDefaultNotebook();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Notebook',
      themeMode: themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: ref.read(userRepositoryProvider).hasSeenOnboarding(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final hasUser = snapshot.data ?? false;

          return hasUser ? DiaryPage(
            notebookId: defaultNotebook!,
          ) : const OnboardingScreen();
        },
      ),
    );
  }
}
