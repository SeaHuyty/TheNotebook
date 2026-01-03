import 'package:flutter/material.dart';
import 'package:the_notebook/features/diary/data/repositories/diary_repository.dart';
import 'package:the_notebook/features/diary/data/repositories/task_repository.dart';
import 'package:the_notebook/features/notebook/data/repository/notebook_repository.dart';
import 'package:the_notebook/features/notebook/presentation/notebook_page.dart';
import 'package:the_notebook/features/onboarding/presentation/pages/onboarding_page.dart';

const asset1 = "assets/images/open-book.svg";
const asset2 = "assets/images/education-note.svg";
const asset3 = "assets/images/notepad-checklist.svg";

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen(
      {super.key,
      required this.diaryRepo,
      required this.notebookRepo,
      required this.taskRepo});

  final DiaryRepository diaryRepo;
  final NotebookRepository notebookRepo;
  final TaskRepository taskRepo;

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
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => NotebookPage(
                    notebookRepo: widget.notebookRepo,
                    diaryRepo: widget.diaryRepo,
                    taskRepo: widget.taskRepo,
                  )));
    }
  }

  void onSkipped() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => NotebookPage(
                  notebookRepo: widget.notebookRepo,
                  diaryRepo: widget.diaryRepo,
                  taskRepo: widget.taskRepo,
                )));
  }

  Widget buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_totalPage, (index) {
        final bool isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 10),
          width: isActive ? 44 : 12, // Wider rectangle when active
          height: 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6), // Small rounded corners
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
