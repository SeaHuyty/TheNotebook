class UserModel {
  final int? id;
  final bool hasSeenOnboarding;
  final DateTime? createdAt;
  final int? defaultNotebook;

  UserModel({
    this.id,
    required this.hasSeenOnboarding,
    this.createdAt,
    this.defaultNotebook
  });
}