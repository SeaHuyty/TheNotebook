import 'package:drift/drift.dart';
import 'package:the_notebook/core/database/database.dart';
import 'package:the_notebook/core/models/diary_image.dart';

class DiaryImageRepository {
  final AppDatabase _db = AppDatabase();

  DiaryImageRepository();

  Future<int> insertImage(DiaryImageModel image, int diaryId) async {
    return await _db.into(_db.diaryImages).insert(
          DiaryImagesCompanion.insert(
            imagePath: image.imagePath,
            isLandscape: Value(image.isLandscape),
            diaryId: Value(diaryId),
          ),
        );
  }

  Future<List<DiaryImageModel>?> getImagesByDiaryId(int diaryId) async {
    final List<DiaryImageModel> diaryImages = [];
    final query = _db.select(_db.diaryImages)
      ..where((tbl) => tbl.diaryId.equals(diaryId));

    final images = await query.get();
    if (images.isEmpty) return null;

    for (var image in images) {
      diaryImages.add(DiaryImageModel(
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
