import 'package:the_notebook/core/database/database.dart';

class DiaryImageModel {
  final int? id;
  final int? diaryId;
  final String imagePath;
  final bool isLandscape;

  const DiaryImageModel(
      {this.id,
      this.diaryId,
      required this.imagePath,
      required this.isLandscape});

  factory DiaryImageModel.fromDrift(DiaryImage image) {
    return DiaryImageModel(
      id: image.id,
      diaryId: image.diaryId,
      imagePath: image.imagePath, 
      isLandscape: image.isLandscape!,
    );
  }
}
