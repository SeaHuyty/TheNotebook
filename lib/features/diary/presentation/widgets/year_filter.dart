import 'package:flutter/material.dart';
import 'package:the_notebook/features/diary/domain/diary.dart';

class YearFilter extends StatelessWidget {
  final String currentYear;
  final List<Diary> sortedEntries;

  const YearFilter({super.key, required this.currentYear, required this.sortedEntries});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}