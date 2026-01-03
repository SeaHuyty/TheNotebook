import 'package:drift/drift.dart';
import './connection/database_connection.dart';

part 'database.g.dart';

class Notebooks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get icon => text()();
  IntColumn get color => integer().nullable()(); 
}

class Diaries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get content => text()();
}

class DiaryImages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get diaryId => integer().nullable().references(Diaries, #id)();
  TextColumn get imagePath => text()();
  BoolColumn get isLandscape => boolean().nullable()();
}

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get diaryId => integer().nullable().references(Diaries, #id)();
  IntColumn get parentTaskId => integer().nullable().references(Tasks, #id)();
}

@DriftDatabase(tables: [Notebooks, Diaries, DiaryImages, Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(openConnection());
  
  static final AppDatabase _instance = AppDatabase._internal();

  factory AppDatabase() => _instance;
  
  @override
  int get schemaVersion => 3;
}
