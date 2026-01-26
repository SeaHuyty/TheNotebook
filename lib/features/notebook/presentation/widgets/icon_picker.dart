import 'package:flutter/material.dart';

class IconPicker extends StatelessWidget {
  final String selectedIcon;
  final List<String> availableIcons;
  final ValueChanged<String> onIconChange;

  const IconPicker(
      {super.key,
      required this.selectedIcon,
      required this.availableIcons,
      required this.onIconChange});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 11,
      runSpacing: 11,
      children: availableIcons.map((icon) {
        final isSelected = icon == selectedIcon;
        return GestureDetector(
          onTap: () => onIconChange(icon),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  width: 2,
                )),
            child: AnimatedScale(
                scale: isSelected ? 0.85 : 1.0,
                duration: Duration(milliseconds: 150),
                child: Image.asset(icon,
                    fit: BoxFit.contain, width: 40, height: 40)),
          ),
        );
      }).toList(),
    );
  }
}
