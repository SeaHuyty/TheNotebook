import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minimal_diary/features/diary/data/repositories/diary_repository.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:visibility_detector/visibility_detector.dart';
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
  String currentMonth = 'Nov';
  final ScrollController _scrollController = ScrollController();
  DiaryRepository repository = DiaryRepository();

  // Sort entries by date (newest first)
  late List sortedEntries = List.from(repository.getDiaryEntries())
    ..sort((a, b) => a['date'].compareTo(b['date']));

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
                final isLastEntry = index == sortedEntries.length - 1;
                return VisibilityDetector(
                  key: Key('diary-entry-$index'),
                  onVisibilityChanged: (VisibilityInfo info) {
                    // Check if the entry is visible AND positioned at the top
                    if (info.visibleFraction > 0 &&
                        info.visibleBounds.top >= 5) {
                      String entryMonth = DateFormat(
                        'MMM',
                      ).format(entry['date']);
                      if (entryMonth != currentMonth && mounted) {
                        setState(() {
                          currentMonth = entryMonth;
                        });
                      }
                    }
                  },
                  child: DiaryTimelineWidget(
                    dayNumber: entry['date'].day,
                    showLineBelow: !isLastEntry,
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
                );
              },
            ),
          ),
          Positioned(
            top: 10,
            left: 20,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 250, 250),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                currentMonth,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 122, 171, 255),
                borderRadius: BorderRadius.circular(20)
              ),
              child: IconButton(onPressed: () {}, icon: Icon(Icons.draw_outlined), color: Colors.white,),
            ),
          ),
        ],
      ),
    );
  }
}
