import 'package:flutter/material.dart';
import 'package:the_notebook/features/diary/data/repositories/diary_tag_repository.dart';
import 'package:the_notebook/features/diary/data/repositories/tag_repository.dart';
import 'package:the_notebook/features/diary/domain/tag.dart';

class TagDrawer extends StatefulWidget {
  final int? diaryId;
  final List<Tag>? tags;
  final Function(List<Tag>)? onTagsChanged;

  const TagDrawer({super.key, this.diaryId, this.tags, this.onTagsChanged});

  @override
  State<TagDrawer> createState() => _TagDrawerState();
}

class _TagDrawerState extends State<TagDrawer> {
  final TagRepository _tagRepo = TagRepository();
  final DiaryTagRepository _diaryTagRepo = DiaryTagRepository();
  List<Tag> tags = [];
  Set<int> selectedTagIds = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTags();
  }

  Future<void> loadTags() async {
    final loadedTags = await _tagRepo.getAllTags();

    if (mounted) {
      setState(() {
        tags = loadedTags;
        if (widget.tags != null) {
          selectedTagIds = widget.tags!
              .where((tag) => tag.id != null)
              .map((tag) => tag.id!)
              .toSet();
        }
        isLoading = false;
      });
    }
  }

  Future<void> toggleTag(Tag tag) async {
    if (tag.id == null || widget.diaryId == null) return;

    setState(() {
      if (selectedTagIds.contains(tag.id)) {
        selectedTagIds.remove(tag.id);
      } else {
        selectedTagIds.add(tag.id!);
      }
    });

    if (widget.diaryId != null) {
      try {
        if (selectedTagIds.contains(tag.id)) {
          await _diaryTagRepo.insertTagToDiary(tag.id!, widget.diaryId!);
        } else {
          await _diaryTagRepo.deleteTagFromDiary(tag.id!, widget.diaryId!);
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            if (selectedTagIds.contains(tag.id)) {
              selectedTagIds.remove(tag.id);
            } else {
              selectedTagIds.add(tag.id!);
            }
          });
        }
        return;
      }
    }

    if (widget.onTagsChanged != null) {
      final selectedTags = tags
          .where((tag) => tag.id != null && selectedTagIds.contains(tag.id))
          .toList();

      widget.onTagsChanged!(selectedTags);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 10),
                const Text('Tags', style: TextStyle(fontSize: 18)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.add))
              ],
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : tags.isEmpty
                      ? const Center(child: Text('No tags available'))
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: tags.length,
                          itemBuilder: (context, index) {
                            final tag = tags[index];
                            final isChecked = tag.id != null &&
                                selectedTagIds.contains(tag.id);

                            return CheckboxListTile(
                              value: isChecked,
                              onChanged: widget.diaryId != null
                                  ? (bool? value) => toggleTag(tag)
                                  : null,
                              title: Text(tag.name),
                              controlAffinity: ListTileControlAffinity.leading,
                            );
                          }),
            ),
          ],
        ),
      ),
    );
  }
}
