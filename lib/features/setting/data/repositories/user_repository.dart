import 'package:drift/drift.dart';
import 'package:the_notebook/core/database/database.dart';

class UserRepository {
  final AppDatabase _db = AppDatabase();

  UserRepository();

  Future<bool> hasUser() async {
    final users = await _db.select(_db.users).get();
    return users.isNotEmpty;
  }

  Future<int> createUser() async {
    return await _db
        .into(_db.users)
        .insert(UsersCompanion.insert(hasSeenOnboarding: Value(true)));
  }
}
