class User {
  final int? id;
  final bool hasSeenOnboarding;
  final DateTime? createdAt;

  User({
    this.id,
    required this.hasSeenOnboarding,
    this.createdAt
  });
}