import 'package:flutter/material.dart';
import 'package:the_notebook/core/utils/formatters.dart';

class LabelChip extends StatelessWidget {
  final Icon icon;
  final String? tag;
  final TimeOfDay? time;
  final DateTime? date;

  const LabelChip(
      {super.key, required this.icon, this.tag, this.time, this.date});

  @override
  Widget build(BuildContext context) {
    String text = '';

    if (time != null) {
      text = formatTime(time!, context);
    } else if (tag != null) {
      text = tag!;
    } else if (date != null) {
      text = formatDaysAgo(date!);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: Colors.grey.shade300, borderRadius: BorderRadius.circular(8)),
      child: Row(
        spacing: 5,
        mainAxisSize: MainAxisSize.min,
        children: [icon, Text(text)],
      ),
    );
  }
}