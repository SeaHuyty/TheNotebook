import 'package:drift/drift.dart';
import './connection/database_connection.dart';

part 'database.g.dart';

class Diaries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get content => text()();
  TextColumn get imageUrl => text().nullable()();
}

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
  IntColumn get diaryId => integer().nullable().references(Diaries, #id)();
  IntColumn get parentTaskId => integer().nullable().references(Tasks, #id)();
}

@DriftDatabase(tables: [Diaries, Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(openConnection());
  
  static final AppDatabase _instance = AppDatabase._internal();

  factory AppDatabase() => _instance;
  
  @override
  int get schemaVersion => 1;
}
