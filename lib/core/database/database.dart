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
  TextColumn get title => text()();
  TextColumn get content => text().nullable()();
  TextColumn get time => text()();
  IntColumn get notebookId => integer().references(Notebooks, #id)();
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

class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().unique()();
}

class DiaryTags extends Table {
  IntColumn get diaryId => integer().references(Diaries, #id, onDelete: KeyAction.cascade)();
  IntColumn get tagId => integer().references(Tags, #id, onDelete: KeyAction.cascade)();
}

@DriftDatabase(tables: [Notebooks, Diaries, DiaryImages, Tasks, Tags, DiaryTags])
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(openConnection());
  
  static final AppDatabase _instance = AppDatabase._internal();

  factory AppDatabase() => _instance;
  
  @override
  int get schemaVersion => 7;
}
