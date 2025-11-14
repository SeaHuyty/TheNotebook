import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/diary_timeline_widget.dart';
import '../widgets/diary_entry_content.dart';
import '../../../../shared/widgets/app_drawer.dart';

class Diary extends StatefulWidget {
  const Diary({super.key});

  @override
  State<Diary> createState() => _DiaryState();
}

class _DiaryState extends State<Diary> {
  // This widget is the root of your application.
  bool isCalendarVisible = false;
  DateTime selectedDate = DateTime.now();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> diaryEntries = [
    {
      'date': DateTime(2025, 11, 1),
      'content': 'Had a wonderful morning walk in the park.',
      'imageUrl': '/images/image-1.png',
    },
    {
      'date': DateTime(2025, 11, 2),
      'content': 'Learned Flutter today, very exciting!',
      'imageUrl': null,
    },
    {
      'date': DateTime(2025, 11, 3),
      'content': 'Had a wonderful morning walk in the park.',
      'imageUrl': '/images/image-2.png',
    },
    {
      'date': DateTime(2025, 11, 5),
      'content': 'Learned Flutter today, very exciting!',
      'imageUrl': null,
    },
    {
      'date': DateTime(2025, 10, 7),
      'content': 'Today was amazing, built my first diary app!',
      'imageUrl': '/images/image-3.png',
    },
    {
      'date': DateTime(2025, 10, 4),
      'content': 'November started great with family dinner.',
      'imageUrl': '/images/image-4.png',
    },
    {
      'date': DateTime(2025, 10, 6),
      'content': 'Rainy day but productive coding session.',
      'imageUrl': '/images/image-5.png',
    },
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sort entries by date (newest first)
    final sortedEntries = List.from(diaryEntries)
      ..sort((a, b) => a['date'].compareTo(b['date']));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu_rounded),
            );
          },
        ),
        actions: [
          InkWell(
            onTap: () {
              setState(() {
                isCalendarVisible = !isCalendarVisible;
              });
            },
            child: Padding(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat('MMM dd, yyyy').format(DateTime.now()),
                    style: TextStyle(fontSize: 16),
                  ),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(currentPage: 'diary'),
      body: Stack(
        children: [
          if (isCalendarVisible)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Material(
                elevation: 3,
                child: TableCalendar(
                  focusedDay: DateTime.now(),
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.now(),
                  calendarFormat: CalendarFormat.month,
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                  },
                  availableGestures: AvailableGestures.all,
                  pageJumpingEnabled: true,
                ),
              ),
            ),
          Positioned(
            left: 40,
            top: 0,
            bottom: 0,
            child: Container(width: 2, color: Colors.grey.shade400),
          ),
          ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 300,
              ),
              itemCount: sortedEntries.length,
              itemBuilder: (context, index) {
                final entry = sortedEntries[index];
                return Column(
                  children: [
                    DiaryTimelineWidget(
                      dayNumber: entry['date'].day,
                      child: Card(
                        color: Colors.transparent,
                        elevation: 0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: DiaryEntryContent(
                            date: DateFormat(
                              'MMM, dd, yyyy',
                            ).format(entry['date']),
                            content: entry['content'],
                            imageUrl: entry['imageUrl'],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
