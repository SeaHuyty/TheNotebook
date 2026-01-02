import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

const transparentColor = "assets/images/transparent.png";

class ColorBlock extends StatelessWidget {
  final Color selectedColor;
  final List<Color> availableColors;
  final ValueChanged<Color> onColorChange;

  const ColorBlock(
      {super.key,
      required this.selectedColor,
      required this.availableColors,
      required this.onColorChange});

  @override
  Widget build(BuildContext context) {
    return BlockPicker(
      pickerColor: selectedColor,
      availableColors: availableColors,
      onColorChanged: onColorChange,
      layoutBuilder: (context, colors, child) {
        return Wrap(
          spacing: 11,
          runSpacing: 11,
          children: colors.map((color) => child(color)).toList(),
        );
      },
      itemBuilder: (color, isCurrent, changeColor) {
        return GestureDetector(
          onTap: changeColor,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: isCurrent ? Colors.blue : Colors.transparent,
                width: 2,
              ),
            ),
            child: Center(
              child: Container(
                width: isCurrent ? 30 : 40,
                height: isCurrent ? 30 : 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color == Colors.transparent ? null : color,
                  image: color == Colors.transparent
                      ? DecorationImage(
                          image: AssetImage(transparentColor),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
