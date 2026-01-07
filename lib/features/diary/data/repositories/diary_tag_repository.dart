import 'package:the_notebook/core/database/database.dart';

class DiaryTagRepository {
  final AppDatabase _db = AppDatabase();

  DiaryTagRepository();

  Future<int> insertTagToDiary(int tagId, int diaryId) async {
    return await _db
        .into(_db.diaryTags)
        .insert(DiaryTagsCompanion.insert(diaryId: diaryId, tagId: tagId));
  }
}
