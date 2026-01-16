import 'package:drift/drift.dart';
import 'package:the_notebook/core/database/database.dart';

class UserRepository {
  final AppDatabase _db = AppDatabase();

  UserRepository();

  Future<bool> hasSeenOnboarding() async {
    final users = await _db.select(_db.users).get();
    if (users.isEmpty) {
      return false;
    }
    return users.first.hasSeenOnboarding;
  }

  Future<int> createUser(int notebookId) async {
    return await _db.into(_db.users).insert(UsersCompanion.insert(
        hasSeenOnboarding: Value(false), defaultNotebook: notebookId));
  }

  Future<int?> getDefaultNotebook() async {
    final users = await _db.select(_db.users).get();
    if (users.isEmpty) {
      return null;
    }
    return users.first.defaultNotebook;
  }
}
