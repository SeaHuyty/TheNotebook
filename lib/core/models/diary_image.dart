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
}
