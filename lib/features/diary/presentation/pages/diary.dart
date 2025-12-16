import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minimal_diary/features/diary/data/repositories/diary_repository.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
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
  final ItemScrollController _scrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  DiaryRepository repository = DiaryRepository();

  // Sort entries by date (newest first)
  late List sortedEntries = List.from(repository.getDiaryEntries())
    ..sort((a, b) => a['date'].compareTo(b['date']));

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.isAttached) {
        _scrollController.jumpTo(index: sortedEntries.length - 1);
      }
    });
  }

  @override
  void dispose() {
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
              icon: const Icon(Icons.menu_rounded),
            );
          },
        ),
        actions: [
          MonthFilter(
            currentMonth: currentMonth,
            sortedEntries: sortedEntries,
            scrollController: _scrollController,
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
          ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: ScrollablePositionedList.builder(
              itemScrollController: _scrollController,
              itemPositionsListener: _itemPositionsListener,
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
                        info.visibleBounds.top >= 0) {
                      String entryMonth = DateFormat(
                        'MMMM',
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
            bottom: 16,
            left: 16,
            right: 16,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: const Color.fromARGB(255, 122, 171, 255),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                  FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: const Color.fromARGB(255, 122, 171, 255),
                    child: const Icon(Icons.draw_outlined, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MonthFilter extends StatelessWidget {
  const MonthFilter({
    super.key,
    required this.currentMonth,
    required this.sortedEntries,
    required ItemScrollController scrollController,
  }) : _scrollController = scrollController;

  final String currentMonth;
  final List sortedEntries;
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
            Icon(Icons.arrow_drop_down, color: Colors.black),
          ],
        ),
        onSelected: (String month) {
          int index = sortedEntries.indexWhere((entry) {
            String entryMonth = DateFormat('MMMM').format(entry['date']);
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
              .map((entry) => DateFormat('MMMM').format(entry['date']))
              .toSet();

          return uniqueMonths.map((String month) {
            return PopupMenuItem(value: month, child: Text(month));
          }).toList();
        },
      ),
    );
  }
}
