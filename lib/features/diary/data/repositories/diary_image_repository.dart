import 'package:drift/drift.dart';
import 'package:the_notebook/core/database/database.dart';
import 'package:the_notebook/features/diary/domain/diary_image.dart' as domain;

class DiaryImageRepository {
  final AppDatabase _db = AppDatabase();

  DiaryImageRepository();

  Future<int> insertImage(domain.DiaryImage image, int diaryId) async {
    return await _db.into(_db.diaryImages).insert(
          DiaryImagesCompanion.insert(
            imagePath: image.imagePath,
            isLandscape: Value(image.isLandscape),
            diaryId: Value(diaryId),
          ),
        );
  }

  Future<domain.DiaryImage?> getImageByDiaryId(int diaryId) async {
    final query = _db.select(_db.diaryImages)
      ..where((tbl) => tbl.diaryId.equals(diaryId));

    final image = await query.getSingleOrNull();
    if (image == null) return null;

    return domain.DiaryImage(
        id: image.id,
        diaryId: image.diaryId,
        imagePath: image.imagePath,
        isLandscape: image.isLandscape!);
  }

  Future<void> deleteImageByDiaryId(int diaryId) async {
    // .go() - Execute the delete
    
    await (_db.delete(_db.diaryImages)
          ..where((tbl) => tbl.diaryId.equals(diaryId)))
        .go();
  }

  void dispose() {
    _db.close();
  }
}
