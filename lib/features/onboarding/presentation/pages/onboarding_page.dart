import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String subTitle;
  final String buttonText;
  final String assetName;
  final double width;
  final VoidCallback onPressed;
  final bool isLastPage;
  final VoidCallback onSkipped;

  const OnboardingPage(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.buttonText,
      required this.assetName,
      this.width = 180,
      required this.onPressed,
      required this.isLastPage,
      required this.onSkipped});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            SvgPicture.asset(
              assetName,
              width: width,
            ),
            SizedBox(height: 30),
            Text(
              title,
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF292524)),
            ),
            Text(subTitle,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600),
                textAlign: TextAlign.center),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 122, 171, 255),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              onPressed: onPressed,
              child: Text(
                buttonText,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            if (!isLastPage)
              TextButton(
                  onPressed: onSkipped,
                  child: Text(
                    "Skip",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600),
                  ))
          ],
        ),
      ),
    );
  }
}
