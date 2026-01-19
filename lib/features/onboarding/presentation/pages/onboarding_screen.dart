import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_notebook/core/providers/repository_providers.dart';
import 'package:the_notebook/features/diary/presentation/pages/diary.dart';

import 'package:the_notebook/features/onboarding/presentation/pages/onboarding_page.dart';

const asset1 = "assets/images/open-book.svg";
const asset2 = "assets/images/education-note.svg";
const asset3 = "assets/images/notepad-checklist.svg";

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  late final userRepo = ref.read(userRepositoryProvider);
  int _currentPage = 0;
  final int _totalPage = 3;
  late int? defaultNotebook;

  @override
  void initState() {
    loadDefaultNotebook();
    super.initState();
  }

  void loadDefaultNotebook() async {
    defaultNotebook = await userRepo.getDefaultNotebook();
  }

  void setSeenOnboarding() async {
    await userRepo.setOnboarding();
  }

  void nextPage() async {
    if (_currentPage < _totalPage - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      setSeenOnboarding();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DiaryPage(
              notebookId: defaultNotebook!,
            ),
          ),
        );
      }
    }
  }

  void onSkipped() async {
    setSeenOnboarding();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DiaryPage(
            notebookId: defaultNotebook!,
          ),
        ),
      );
    }
  }

  Widget buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_totalPage, (index) {
        final bool isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 10),
          width: isActive ? 44 : 12,
          height: 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: isActive ? const Color(0xFF292524) : Colors.grey,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  OnboardingPage(
                    title: "Welcome to TheNotebook",
                    subTitle:
                        "A flexible space for your thoughts, tasks, and everything in between",
                    buttonText: "Next",
                    assetName: asset1,
                    onPressed: nextPage,
                    isLastPage: false,
                    onSkipped: onSkipped,
                    backButton: false,
                    pageIndicator: buildPageIndicator(),
                  ),
                  OnboardingPage(
                    title: "Create Custom Notebooks",
                    subTitle:
                        "Organize your life with notebooks tailored to your needs. All your life journey in one place",
                    buttonText: "Next",
                    assetName: asset2,
                    onPressed: nextPage,
                    isLastPage: false,
                    onSkipped: onSkipped,
                    backButton: true,
                    onBackPressed: () {
                      _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    },
                    pageIndicator: buildPageIndicator(),
                  ),
                  OnboardingPage(
                    title: "Stay Organized, Your Way",
                    subTitle:
                        "Track tasks, journal your thoughts, or do both in one seamless experience.",
                    buttonText: "Get Started",
                    assetName: asset3,
                    onPressed: nextPage,
                    isLastPage: true,
                    onSkipped: onSkipped,
                    backButton: true,
                    onBackPressed: () {
                      _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    },
                    pageIndicator: buildPageIndicator(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30)
          ],
        ),
      ),
    );
  }
}
