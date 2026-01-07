import 'package:drift/drift.dart';
import 'package:the_notebook/core/database/database.dart';
import 'package:the_notebook/features/diary/domain/tag.dart' as domain;

class TagRepository {
  final AppDatabase _db = AppDatabase();

  TagRepository();

  Future<int> insertTag(domain.Tag tag) async {
    return await _db
        .into(_db.tags)
        .insert(TagsCompanion.insert(title: tag.name));
  }

  Future<List<domain.Tag>> getAllTags() async {
    final tags = await _db.select(_db.tags).get();
    final result = <domain.Tag>[];

    for (var tag in tags) {
      result.add(domain.Tag(name: tag.title, id: tag.id));
    }

    return result;
  }

  Future<List<domain.Tag>> getTagsForDiary(int diaryId) async {
    final query = _db.select(_db.tags).join(
        [innerJoin(_db.diaryTags, _db.diaryTags.tagId.equalsExp(_db.tags.id))])
      ..where(_db.diaryTags.diaryId.equals(diaryId));

    final results = await query.get();

    return results.map((row) {
      final tag = row.readTable(_db.tags);
      return domain.Tag(name: tag.title, id: tag.id);
    }).toList();
  }

  void dispose() {
    _db.close();
  }
}
