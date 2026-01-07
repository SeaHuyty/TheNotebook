import 'package:flutter/material.dart';

class CustomRadio extends StatelessWidget {
  final bool checked;
  final VoidCallback onTap;
  final double size;

  const CustomRadio({
    super.key,
    required this.checked,
    required this.onTap,
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: checked ? null : Border.all(color: Colors.grey, width: 2),
          color: checked ? Colors.green : Colors.transparent,
        ),
        child: checked
            ? const Icon(Icons.check, size: 12, color: Colors.white)
            : null,
      ),
    );
  }
}
