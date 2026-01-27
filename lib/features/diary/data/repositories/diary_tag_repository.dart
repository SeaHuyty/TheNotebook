import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_notebook/core/database/database.dart';

class DiaryTagRepository {
  final AppDatabase _db = AppDatabase();

  DiaryTagRepository();

  Future<int> insertTagToDiary(int tagId, int diaryId) async {
    return await _db
        .into(_db.diaryTags)
        .insert(DiaryTagsCompanion.insert(diaryId: diaryId, tagId: tagId));
  }

  Future<void> deleteTagFromDiary(int tagId, int diaryId) async {
    await (_db.delete(_db.diaryTags)
          ..where(
              (tbl) => tbl.diaryId.equals(diaryId) & tbl.tagId.equals(tagId)))
        .go();
  }

  void dispose() {
    _db.close();
  }
}

final diaryTagRepositoryProvider = Provider<DiaryTagRepository>((ref) {
  return DiaryTagRepository();
});