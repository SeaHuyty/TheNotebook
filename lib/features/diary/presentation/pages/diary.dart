import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_notebook/features/diary/data/repositories/diary_repository.dart';
import 'package:the_notebook/features/diary/domain/diary.dart';
import 'package:the_notebook/features/diary/presentation/pages/create_diary.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:the_notebook/features/diary/presentation/pages/diary_detail.dart';
import 'package:the_notebook/features/diary/presentation/widgets/month_filter.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../widgets/diary_timeline_widget.dart';
import '../widgets/diary_entry_content.dart';

class DiaryPage extends StatefulWidget {
  final DiaryRepository repo;

  const DiaryPage({super.key, required this.repo});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  bool isCalendarVisible = false;
  DateTime selectedDate = DateTime.now();
  String currentMonth = DateTime.now().month.toString();
  final ItemScrollController _scrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  int selectedYear = DateTime.now().year;
  List<int> availableYears = [];

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

      availableYears = sortedEntries
          .map((entry) => entry.date.year)
          .toSet()
          .toList()
        ..sort((a, b) => b.compareTo(a));
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

  List<Diary> getFilteredEntries() {
    return sortedEntries
        .where((entry) => entry.date.year == selectedYear)
        .toList();
  }

  void showYearFilter() {
    showModalBottomSheet(
        context: context,
        builder: (context) => Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: availableYears.length,
                      itemBuilder: (context, index) => ListTile(
                            title: Text(availableYears[index].toString()),
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                selectedYear = availableYears[index];
                              });
                            },
                          )),
                )
              ],
            ));
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

  void onCreate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CreateDiaryPage(
                repo: widget.repo,
              )),
    );

    if (result == true) {
      loadEntries();
    }
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
        actions: [
          MonthFilter(
            currentMonth: currentMonth,
            sortedEntries: sortedEntries,
            scrollController: _scrollController,
          ),
        ],
      ),
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
                    itemCount: getFilteredEntries().length,
                    itemBuilder: (context, index) {
                      final filteredEntries = getFilteredEntries();
                      final entry = filteredEntries[index];
                      final isLastEntry = index == filteredEntries.length - 1;
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
                          child: GestureDetector(
                            onTap: () async {
                              final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DiaryDetailPage(
                                          diary: entry, repo: widget.repo)));

                              if (result == true) {
                                loadEntries();
                              }
                            },
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
                                  image: entry.image,
                                  tasks: entry.tasks,
                                ),
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
            left: 20,
            right: 20,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: FloatingActionButton(
                      heroTag: 'filter',
                      onPressed: showYearFilter,
                      backgroundColor: const Color.fromARGB(255, 122, 171, 255),
                      child: const Icon(
                        Icons.tune,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: FloatingActionButton(
                      heroTag: 'create',
                      onPressed: onCreate,
                      backgroundColor: const Color.fromARGB(255, 122, 171, 255),
                      child: const Icon(
                        Icons.draw_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
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
