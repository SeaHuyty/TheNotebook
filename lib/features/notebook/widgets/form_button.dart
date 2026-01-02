import 'package:flutter/material.dart';

class FormButton extends StatelessWidget {
  final Color textColor;
  final String buttonText;
  final Color? buttonColor;
  final VoidCallback onPressed;

  const FormButton(
      {super.key,
      required this.textColor,
      required this.buttonText,
      this.buttonColor,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20),
        foregroundColor: textColor,
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Text(buttonText, style: TextStyle(fontSize: 16)),
    );
  }
}
