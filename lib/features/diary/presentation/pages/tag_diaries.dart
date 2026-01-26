import 'package:flutter/material.dart';
import 'package:the_notebook/core/models/tag.dart';
import 'package:the_notebook/core/models/diary.dart';
import 'package:the_notebook/features/diary/data/repositories/tag_repository.dart';
import 'package:the_notebook/features/diary/data/repositories/diary_repository.dart';
import 'package:the_notebook/features/diary/presentation/pages/diary_detail.dart';
import 'package:the_notebook/features/diary/presentation/widgets/diary_entry_content.dart';
import 'package:the_notebook/features/diary/presentation/widgets/diary_timeline_widget.dart';

class TagDiaries extends StatefulWidget {
  const TagDiaries({super.key});

  @override
  State<TagDiaries> createState() => _TagDiariesState();
}

class _TagDiariesState extends State<TagDiaries> {
  final TagRepository _tagRepo = TagRepository();
  final DiaryRepository _diaryRepo = DiaryRepository();
  List<TagModel> loadedTags = [];
  List<DiaryModel> allDiaries = [];
  List<DiaryModel> filteredDiaries = [];
  Set<int> selectedTagIds = {};
  Map<int, int> tagDiaryCounts = {};

  Future<void> loadData() async {
    loadedTags = await _tagRepo.getAllTags();
    allDiaries = await _diaryRepo.getDiaryEntries();

    // Calculate diary counts for each tag
    tagDiaryCounts.clear();
    for (var tag in loadedTags) {
      final count = allDiaries.where((diary) {
        return diary.tags?.any((t) => t.id == tag.id) ?? false;
      }).length;
      tagDiaryCounts[tag.id!] = count;
    }

    setState(() {
      filterDiaries();
    });
  }

  void filterDiaries() {
    if (selectedTagIds.isEmpty) {
      filteredDiaries = [];
    } else {
      filteredDiaries = allDiaries.where((diary) {
        return diary.tags?.any((t) => selectedTagIds.contains(t.id)) ?? false;
      }).toList();

      filteredDiaries.sort((a, b) => b.date.compareTo(a.date));
    }
  }

  void toggleTag(int tagId) {
    setState(() {
      if (selectedTagIds.contains(tagId)) {
        selectedTagIds.remove(tagId);
      } else {
        selectedTagIds.add(tagId);
      }
      filterDiaries();
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tags'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: loadedTags.length,
                itemBuilder: (context, index) {
                  final tag = loadedTags[index];
                  final isSelected = selectedTagIds.contains(tag.id);
                  final count = tagDiaryCounts[tag.id] ?? 0;

                  return GestureDetector(
                    onTap: () => toggleTag(tag.id!),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                          width: isSelected ? 2 : 1,
                        ),
                        color: isSelected
                            ? Theme.of(context).primaryColor.withOpacity(0.1)
                            : Colors.transparent,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$count',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Theme.of(context).primaryColor
                                    : null,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              tag.name,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? Theme.of(context).primaryColor
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (selectedTagIds.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  'Select tags to view diaries',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else if (filteredDiaries.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  'No diaries found with selected tags',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: filteredDiaries.length,
                itemBuilder: (context, index) {
                  final entry = filteredDiaries[index];
                  final isLastEntry = index == filteredDiaries.length - 1;

                  return DiaryTimelineWidget(
                    dayNumber: entry.date.day,
                    showLineBelow: !isLastEntry,
                    child: GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiaryDetailPage(
                              diary: entry,
                            ),
                          ),
                        );

                        if (result == true) {
                          loadData();
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
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
