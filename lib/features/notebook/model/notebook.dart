import 'package:flutter/material.dart';

enum NotebookType { life, work, travel, leisure }

class Notebook {
  final int? id;
  final String title;
  final NotebookType category;

  Notebook({
    this.id,
    required this.title,
    required this.category
  });

  IconData get icon {
    switch(category) {
      case NotebookType.life:
        return Icons.home;
      case NotebookType.work:
        return Icons.work;
      case NotebookType.travel:
        return Icons.flight;
      case NotebookType.leisure:
        return Icons.movie;
    }
  }
}