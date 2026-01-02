import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String subTitle;
  final String buttonText;
  final String assetName;
  final double width;
  final bool backButton;
  final VoidCallback onPressed;
  final bool isLastPage;
  final VoidCallback onSkipped;
  final VoidCallback? onBackPressed;
  final Widget? pageIndicator;

  const OnboardingPage(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.buttonText,
      required this.assetName,
      required this.backButton,
      this.width = 180,
      required this.onPressed,
      required this.isLastPage,
      required this.onSkipped,
      this.onBackPressed,
      this.pageIndicator});

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
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF292524)),
            ),
            Text(subTitle,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
                textAlign: TextAlign.center),
            SizedBox(height: 20),
            if (pageIndicator != null) ...[
              pageIndicator!,
              SizedBox(height: 20),
            ],
            Row(
              spacing: 15,
              children: [
                if (backButton)
                  OutlinedButton(
                      onPressed: onBackPressed ?? () {},
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Colors.black45),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 18),
                          overlayColor: Colors.grey),
                      child: Row(
                        spacing: 6,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back_ios),
                          Text(
                            'Back',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ],
                      )),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF292524),
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                    ),
                    onPressed: onPressed,
                    child: buttonText.contains('Next')
                        ? Row(
                            spacing: 6,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                buttonText,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              Icon(Icons.arrow_forward_ios),
                            ],
                          )
                        : Text(
                            buttonText,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                  ),
                ),
              ],
            ),
            if (!isLastPage) ...[
              const SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: onSkipped,
                  child: Text(
                    "Skip",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600),
                  ))
            ]
          ],
        ),
      ),
    );
  }
}
