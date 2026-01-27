import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_notebook/core/database/database.dart';
import 'package:the_notebook/core/models/tag.dart';

class TagRepository {
  final AppDatabase _db = AppDatabase();

  TagRepository();

  Future<int> insertTag(TagModel tag) async {
    return await _db
        .into(_db.tags)
        .insert(TagsCompanion.insert(title: tag.name));
  }

  Future<List<TagModel>> getAllTags() async {
    final tags = await _db.select(_db.tags).get();
    final result = <TagModel>[];

    for (var tag in tags) {
      result.add(TagModel.fromDrift(tag));
    }

    return result;
  }

  Future<List<TagModel>> getTagsForDiary(int diaryId) async {
    final query = _db.select(_db.tags).join(
        [innerJoin(_db.diaryTags, _db.diaryTags.tagId.equalsExp(_db.tags.id))])
      ..where(_db.diaryTags.diaryId.equals(diaryId));

    final results = await query.get();

    return results.map((row) {
      final tag = row.readTable(_db.tags);
      return TagModel.fromDrift(tag);
    }).toList();
  }

  void dispose() {
    _db.close();
  }
}

final tagRepositoryProvider = Provider<TagRepository>((ref) {
  return TagRepository();
});