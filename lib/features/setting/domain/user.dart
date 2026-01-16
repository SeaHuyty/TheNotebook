class User {
  final int? id;
  final bool hasSeenOnboarding;
  final DateTime? createdAt;
  final int? defaultNotebook;

  User({
    this.id,
    required this.hasSeenOnboarding,
    this.createdAt,
    this.defaultNotebook
  });
}