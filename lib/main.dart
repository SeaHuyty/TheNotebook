import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_notebook/core/database/seed/seed_index.dart';
import 'package:the_notebook/core/providers/repository_providers.dart';
import 'package:the_notebook/features/notebook/presentation/notebook_page.dart';
import 'package:the_notebook/features/onboarding/presentation/pages/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final seedRepo = SeedIndex();

  await seedRepo.seedIfEmpty();

  // Develop on Web Browser
  runApp(ProviderScope(
    child: const MyApp(),
    // child: DevicePreview(enabled: true, builder: (context) => const MyApp()),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({
    super.key,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Notebook',
      home: FutureBuilder<bool>(
        future: ref.read(userRepositoryProvider).hasUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          
          final hasUser = snapshot.data ?? false;
          
          return hasUser ? const NotebookPage() : const OnboardingScreen();
        },
      ),
    );
  }
}
