import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatTime(TimeOfDay time, BuildContext context) {
  final now = DateTime.now();
  final dateTime = DateTime(
    now.year,
    now.month,
    now.day,
    time.hour,
    time.minute,
  );
  return DateFormat.jm().format(dateTime); // e.g. 5:30 PM
}

String formatDaysAgo(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date).inDays;

  if (difference == 0) return 'Today';
  if (difference == 1) return 'Yesterday';
  return '$difference days ago';
}