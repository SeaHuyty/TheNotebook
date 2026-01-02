import 'package:flutter/material.dart';

const home = "assets/images/home.png";
const work = "assets/images/work.png";
const travel = "assets/images/travel.png";
const movie = "assets/images/movie.png";
const food = "assets/images/food.png";
const gym = "assets/images/gym.png";
const journal = "assets/images/journal.png";

class Notebook {
  final int? id;
  final String title;
  final String icon;
  final Color? color;

  Notebook({
    this.id,
    required this.title,
    required this.icon,
    this.color,
  });

  final Map<Color, Color> secondaryColor = {
    Colors.lightBlueAccent: Color(0xFF7FD6FF),
    Colors.lightGreenAccent: Color(0xFFC2FC80),
    Colors.orangeAccent: Color(0xFFF4BA6F),
    Colors.purpleAccent: Color(0xFFE07EF9),
    Colors.redAccent: Color(0xFFFF8D8D),
    Colors.yellowAccent: Color(0xFFFFFF81),
    Colors.pinkAccent: Color(0xFFF67BA4),
  };

  Color getSecondaryColor(Color? primary) {
    if (primary == null) {
      return Colors.transparent;
    }
    final normalized = Color(primary.toARGB32());

    return secondaryColor[normalized] ?? Colors.transparent;
  }
}
