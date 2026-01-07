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

  Future<List<domain.DiaryImage>?> getImagesByDiaryId(int diaryId) async {
    final List<domain.DiaryImage> diaryImages = [];
    final query = _db.select(_db.diaryImages)
      ..where((tbl) => tbl.diaryId.equals(diaryId));

    final images = await query.get();
    if (images.isEmpty) return null;

    for (var image in images) {
      diaryImages.add(domain.DiaryImage(
          id: image.id,
          diaryId: image.diaryId,
          imagePath: image.imagePath,
          isLandscape: image.isLandscape!));
    }

    return diaryImages;
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
