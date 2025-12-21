import 'package:flutter/material.dart';
import 'package:minimal_diary/features/diary/presentation/pages/diary.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            Text('Story of your life', style: TextStyle(fontSize: 25)),
            Text(
              'All your journeys in one place.',
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DiaryPage()),
                );
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
