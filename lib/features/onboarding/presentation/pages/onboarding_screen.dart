import 'package:flutter/material.dart';
import 'package:the_notebook/features/diary/data/repositories/diary_repository.dart';
import 'package:the_notebook/features/notebook/data/repository/notebook_repository.dart';
import 'package:the_notebook/features/notebook/presentation/notebook_page.dart';
import 'package:the_notebook/features/onboarding/presentation/pages/onboarding_page.dart';

const asset1 = "assets/images/open-book.svg";
const asset2 = "assets/images/education-note.svg";
const asset3 = "assets/images/notepad-checklist.svg";

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen(
      {super.key, required this.diaryRepo, required this.notebookRepo});

  final DiaryRepository diaryRepo;
  final NotebookRepository notebookRepo;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPage = 3;

  void nextPage() {
    if (_currentPage < _totalPage - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => NotebookPage(
                  notebookRepo: widget.notebookRepo,
                  diaryRepo: widget.diaryRepo)));
    }
  }

  void onSkipped() {
    Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => NotebookPage(
                  notebookRepo: widget.notebookRepo,
                  diaryRepo: widget.diaryRepo)));
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
                    title: "Let's get started",
                    subTitle:
                        "The Notebook - A flexible space for your thoughts, tasks, and everything in between",
                    buttonText: "Next",
                    assetName: asset1,
                    onPressed: nextPage,
                    isLastPage: false,
                    onSkipped: onSkipped,
                  ),
                  OnboardingPage(
                    title: "Customize",
                    subTitle: "Add photos, tasks, and reminders everyday",
                    buttonText: "Next",
                    assetName: asset2,
                    onPressed: nextPage,
                    isLastPage: false,
                    onSkipped: onSkipped,
                  ),
                  OnboardingPage(
                    title: "Story of your life",
                    subTitle: "All your journeys in one place",
                    buttonText: "Get Started",
                    assetName: asset3,
                    onPressed: nextPage,
                    isLastPage: true,
                    onSkipped: onSkipped,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_totalPage, (index) {
                final bool isActive = index == _currentPage;
                return AnimatedScale(
                  duration: const Duration(microseconds: 300),
                  scale: isActive ? 1.5 : 1.0,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? Color(0xFF292524)
                          : Colors.grey,
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 30)
          ],
        ),
      ),
    );
  }
}
