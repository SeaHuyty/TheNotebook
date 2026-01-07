import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:the_notebook/core/providers/repository_providers.dart';
import 'package:the_notebook/features/diary/domain/diary.dart';
import 'package:the_notebook/features/diary/presentation/pages/diary_detail.dart';
import 'package:the_notebook/features/diary/presentation/pages/diary_form.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../widgets/diary_timeline_widget.dart';
import '../widgets/diary_entry_content.dart';

class DiaryPage extends ConsumerStatefulWidget {
  final int notebookId;

  const DiaryPage(
      {super.key,
      required this.notebookId});

  @override
  ConsumerState<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends ConsumerState<DiaryPage> {
  bool isMonthSelectorExpanded = false;
  String currentMonth = DateFormat('MMMM').format(DateTime.now());
  final ItemScrollController _scrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  int selectedYear = DateTime.now().year;
  List<int> availableYears = [];
  Set<String> availableMonths = {};
  List<Diary> sortedEntries = [];
  late final diaryRepository = ref.read(diaryRepositoryProvider);

  @override
  void initState() {
    super.initState();
    loadEntries();
  }

  Future<void> loadEntries() async {
    final entries =
        await diaryRepository.getDiaryEntriesByYear(selectedYear);
    final years = await diaryRepository.getAvailableYears();

    setState(() {
      sortedEntries = entries;
      availableYears = years;
      availableMonths = sortedEntries
          .map((entry) => DateFormat('MMMM').format(entry.date))
          .toSet();
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
                                isMonthSelectorExpanded = false;
                              });
                              loadEntries();
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
        builder: (context) => DiaryFormPage(
              notebookId: widget.notebookId,
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
          TextButton(
              onPressed: () {
                setState(() {
                  isMonthSelectorExpanded = !isMonthSelectorExpanded;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(currentMonth,
                      style: TextStyle(fontSize: 18, color: Colors.black)),
                  const Icon(Icons.arrow_drop_down, color: Colors.black),
                ],
              )),
        ],
      ),
      body: Stack(
        children: [
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
                          child: GestureDetector(
                            onTap: () async {
                              final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DiaryDetailPage(
                                            diary: entry,
                                          )));

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
                                  diary: entry,
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
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      elevation: 0,
                      hoverElevation: 0,
                      focusElevation: 0,
                      highlightElevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(color: Colors.black, width: 0.5)),
                      child: const Icon(
                        Icons.tune,
                        color: Colors.black,
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
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
          if (isMonthSelectorExpanded)
            AnimatedSlide(
              duration: Duration(milliseconds: 300),
              offset: isMonthSelectorExpanded ? Offset(0, 0) : Offset(0, -1),
              child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: availableMonths.length,
                      itemBuilder: (context, index) {
                        final months = availableMonths.toList();
                        final month = months[index];
                        final isSelected = month == currentMonth;

                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: ChoiceChip(
                              label: Text(month.substring(0, 3)),
                              showCheckmark: false,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              selected: isSelected,
                              onSelected: (isSelected) {
                                int index = sortedEntries.indexWhere((entry) {
                                  String entryMonth =
                                      DateFormat('MMMM').format(entry.date);
                                  return entryMonth == month;
                                });

                                if (index != -1) {
                                  _scrollController.scrollTo(
                                    index: index,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                }

                                setState(() {
                                  currentMonth = month;
                                  isMonthSelectorExpanded = false;
                                });
                              }),
                        );
                      })),
            ),
        ],
      ),
    );
  }
}
