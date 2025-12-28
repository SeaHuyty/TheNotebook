import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// Define your tables
class Diaries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get content => text()();
  TextColumn get imageUrl => text().nullable()();
}

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().nullable()();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
  IntColumn get diaryId => integer().nullable().references(Diaries, #id)();
  IntColumn get parentTaskId => integer().nullable().references(Tasks, #id)();
}

@DriftDatabase(tables: [Diaries, Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
