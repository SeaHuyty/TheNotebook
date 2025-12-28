import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_notebook/features/diary/data/repositories/diary_repository.dart';
import 'package:the_notebook/features/diary/domain/diary.dart';
import 'package:the_notebook/features/diary/presentation/pages/create_diary.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../widgets/diary_timeline_widget.dart';
import '../widgets/diary_entry_content.dart';
import '../../../../shared/widgets/app_drawer.dart';

class DiaryPage extends StatefulWidget {
  final DiaryRepository repo;

  const DiaryPage({super.key, required this.repo});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  // This widget is the root of your application.
  bool isCalendarVisible = false;
  DateTime selectedDate = DateTime.now();
  String currentMonth = DateTime.now().month.toString();
  final ItemScrollController _scrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  List<Diary> sortedEntries = [];

  @override
  void initState() {
    super.initState();
    loadEntries();
  }

  Future<void> loadEntries() async {
    final entries = await widget.repo.getDiaryEntries();
    setState(() {
      sortedEntries = List.from(entries)
        ..sort((a, b) => a.date.compareTo(b.date));
    });

    // Move the scroll-to-today logic, after data is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.isAttached) {
        // Find the index of today's date or the closest entry
        int todayIndex = _findTodayOrClosestIndex();
        _scrollController.jumpTo(index: todayIndex);
      }
    });
  }

  int _findTodayOrClosestIndex() {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    // Try to find exact match for today
    int exactIndex = sortedEntries.indexWhere((entry) {
      final entryDate = DateTime(
        entry.date.year,
        entry.date.month,
        entry.date.day,
      );
      return entryDate.isAtSameMomentAs(todayDate);
    });

    if (exactIndex != -1) {
      return exactIndex;
    }

    // Find the closest date (prefer the most recent entry before or on today)
    int closestIndex = 0;
    for (int i = 0; i < sortedEntries.length; i++) {
      final entryDate = DateTime(
        sortedEntries[i].date.year,
        sortedEntries[i].date.month,
        sortedEntries[i].date.day,
      );
      if (entryDate.isBefore(todayDate) ||
          entryDate.isAtSameMomentAs(todayDate)) {
        closestIndex = i;
      } else {
        break;
      }
    }

    return closestIndex;
  }

  void onCreate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateDiary()),
    );
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
      drawer: const AppDrawer(currentPage: 'diary'),
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
            child: sortedEntries.isEmpty
                ? Center(child: Text('Loading Data'))
                : ScrollablePositionedList.builder(
                    itemScrollController: _scrollController,
                    itemPositionsListener: _itemPositionsListener,
                    padding: const EdgeInsets.only(
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
                            ).format(entry.date);
                            if (entryMonth != currentMonth && mounted) {
                              setState(() {
                                currentMonth = entryMonth;
                              });
                            }
                          }
                        },
                        child: DiaryTimelineWidget(
                          dayNumber: entry.date.day,
                          showLineBelow: !isLastEntry,
                          child: Card(
                            color: Colors.transparent,
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: DiaryEntryContent(
                                date: DateFormat(
                                  'MMM, dd, yyyy',
                                ).format(entry.date),
                                content: entry.content,
                                imageUrl: entry.imageUrl,
                                tasks: entry.tasks,
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
                    heroTag: 'uniqueTag1',
                    onPressed: onCreate,
                    backgroundColor: const Color.fromARGB(255, 122, 171, 255),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                  FloatingActionButton(
                    heroTag: 'uniqueTag2',
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
