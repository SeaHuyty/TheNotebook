import 'package:flutter/material.dart';
import 'package:the_notebook/features/diary/data/repositories/diary_repository.dart';
import 'package:the_notebook/features/diary/presentation/pages/diary.dart';
import 'package:the_notebook/features/onboarding/presentation/pages/notebook_page.dart';
import 'package:the_notebook/features/onboarding/presentation/pages/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.repo});

  final DiaryRepository repo;

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
        MaterialPageRoute(builder: (context) => const NotebookPage())//DiaryPage(repo: widget.repo)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                  title: "Story of your life",
                  subTitle: "All your journeys in one place.",
                  buttonText: "Next",
                  onPressed: nextPage,
                ),

                OnboardingPage(
                  title: "Story of your life",
                  subTitle: "All your journeys in one place.",
                  buttonText: "Next",
                  onPressed: nextPage,
                ),

                OnboardingPage(
                  title: "Story of your life",
                  subTitle: "All your journeys in one place.",
                  buttonText: "Next",
                  onPressed: nextPage,
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
                scale: isActive ? 1.6 : 1.0,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? const Color.fromARGB(255, 122, 171, 255) : Colors.grey,
                  ),
                ),
              );
            }),
          ),

          SizedBox(height: 30)
        ],
      ),
    );
  }
}
