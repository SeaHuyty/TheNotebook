import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:the_notebook/features/diary/domain/diary.dart';

class MonthFilter extends StatelessWidget {
  const MonthFilter({
    super.key,
    required this.currentMonth,
    required this.sortedEntries,
    required ItemScrollController scrollController,
  }) : _scrollController = scrollController;

  final String currentMonth;
  final List<Diary> sortedEntries;
  final ItemScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PopupMenuButton<String>(
        icon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(currentMonth, style: TextStyle(fontSize: 18)),
            const Icon(Icons.arrow_drop_down, color: Colors.black),
          ],
        ),
        onSelected: (String month) {
          int index = sortedEntries.indexWhere((entry) {
            String entryMonth = DateFormat('MMMM').format(entry.date);
            return entryMonth == month;
          });

          if (index != -1) {
            _scrollController.scrollTo(
              index: index,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        },
        itemBuilder: (BuildContext context) {
          Set<String> uniqueMonths = sortedEntries
              .map((entry) => DateFormat('MMMM').format(entry.date))
              .toSet();

          return uniqueMonths.map((String month) {
            return PopupMenuItem(value: month, child: Text(month));
          }).toList();
        },
      ),
    );
  }
}