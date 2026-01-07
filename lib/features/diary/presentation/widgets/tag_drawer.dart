import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_notebook/core/providers/repository_providers.dart';
import 'package:the_notebook/features/diary/data/repositories/diary_tag_repository.dart';
import 'package:the_notebook/features/diary/data/repositories/tag_repository.dart';
import 'package:the_notebook/features/diary/domain/tag.dart';

class TagDrawer extends ConsumerStatefulWidget {
  final int? diaryId;
  final List<Tag>? tags;
  final Function(List<Tag>)? onTagsChanged;

  const TagDrawer({super.key, this.diaryId, this.tags, this.onTagsChanged});

  @override
  ConsumerState<TagDrawer> createState() => _TagDrawerState();
}

class _TagDrawerState extends ConsumerState<TagDrawer> {
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

  Future<void> addNewTag() async {
    final TextEditingController controller = TextEditingController();

    final tagName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add new tag'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
              hintText: 'Enter tag name', border: OutlineInputBorder()),
          onSubmitted: (value) => Navigator.pop(context, value),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Add'))
        ],
      ),
    );

    if (tagName != null && tagName.trim().isNotEmpty) {
      try {
        final tagRepo = ref.read(tagRepositoryProvider);
        final newTagId = await tagRepo.insertTag(Tag(name: tagName.trim()));
        final Tag tag = Tag(name: tagName, id: newTagId);
        setState(() {
          tags.add(tag);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tag "$tagName" added successfully')),
          );

          toggleTag(tag);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Failed to add tag')));
        }
      }
    }
  }

  Future<void> toggleTag(Tag tag) async {
    if (tag.id == null) return;

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
    final sortedTags = [...tags]..sort((a, b) {
        final aChecked = a.id != null && selectedTagIds.contains(a.id);
        final bChecked = b.id != null && selectedTagIds.contains(b.id);

        if (aChecked && !bChecked) return -1; // a comes first
        if (!aChecked && bChecked) return 1; // b comes first
        return 0; // keep original order
      });

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
                IconButton(onPressed: addNewTag, icon: const Icon(Icons.add))
              ],
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : tags.isEmpty
                      ? const Center(child: Text('No tags available'))
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: sortedTags.length,
                          itemBuilder: (context, index) {
                            final tag = sortedTags[index];
                            final isChecked = tag.id != null &&
                                selectedTagIds.contains(tag.id);

                            return CheckboxListTile(
                              value: isChecked,
                              onChanged: (bool? value) => toggleTag(tag),
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
