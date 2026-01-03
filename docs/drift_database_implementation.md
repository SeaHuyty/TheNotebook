# Drift Database Implementation Guide

## Overview

This guide explains how to implement Drift database in a Flutter application that works on both **mobile** (using SQLite) and **web** (using WASM/IndexedDB).

---

## 1. Installation

### Add Dependencies

```bash
flutter pub add drift path_provider path
flutter pub add --dev drift_dev build_runner
```

### For Web Support (WASM)

```bash
flutter pub add universal_io
```

Your `pubspec.yaml` should include:

```yaml
dependencies:
  drift: ^2.30.0
  path_provider: ^2.1.5
  path: ^1.9.1
  universal_io: ^2.2.2

dev_dependencies:
  drift_dev: ^2.30.0
  build_runner: ^2.10.4
```

---

## 2. Setup WASM Files for Web

Download these files and place them in your `web/` folder:

- `sqlite3.wasm` - from https://github.com/simolus3/sqlite3.dart/releases
- `drift_worker.js` - from https://github.com/simolus3/drift/releases

*Note: Make sure to download the file listed in your sqlite3 version*

---

## 3. Database Connection Setup

### Create Connection Files

#### `lib/core/database/connection/database_connection.dart`

```dart
import 'package:drift/drift.dart';

// Conditional imports
import 'database_connection_native.dart'
    if (dart.library.html) 'database_connection_web.dart';

QueryExecutor openConnection() {
  return createDriftConnection();
}
```

#### `lib/core/database/connection/database_connection_native.dart`

```dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

QueryExecutor createDriftConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'notebook.db'));
    return NativeDatabase(file);
  });
}
```

#### `lib/core/database/connection/database_connection_web.dart`

```dart
import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

QueryExecutor createDriftConnection() {
  return LazyDatabase(() async {
    final result = await WasmDatabase.open(
      databaseName: 'notebook_db',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );
    return result.resolvedExecutor;
  });
}
```

---

## 4. Define Database Schema

### `lib/core/database/database.dart`

```dart
import 'package:drift/drift.dart';
import './connection/database_connection.dart';

part 'database.g.dart';

// Define tables
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

// Database class with singleton pattern
@DriftDatabase(tables: [Diaries, Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(openConnection());

  static final AppDatabase _instance = AppDatabase._internal();

  factory AppDatabase() => _instance;

  @override
  int get schemaVersion => 1;
}
```

---

## 5. Generate Database Code

Run the build runner:

```bash
dart run build_runner build
```

Or if you want to delete conflicting outputs first::

```bash
dart run build_runner build --delete-conflicting-outputs
```

This generates `database.g.dart` with all the boilerplate code.

---

## 7. Common Drift Queries

### Select All

```dart
final diaries = await _db.select(_db.diaries).get();
```

### Select with Where

```dart
final tasks = await (_db.select(_db.tasks)
  ..where((t) => t.diaryId.equals(diaryId)))
  .get();
```

### Select Single

```dart
final diary = await (_db.select(_db.diaries)
  ..where((t) => t.id.equals(id)))
  .getSingle();
```

### Insert

```dart
final id = await _db.into(_db.diaries).insert(
  DiariesCompanion(
    date: Value(DateTime.now()),
    content: Value('My diary'),
  ),
);
```

### Update

```dart
final diary = Diary(id: 1, date: DateTime.now(), content: 'Updated');
await _db.update(_db.diaries).replace(diary);
```

### Delete

```dart
await (_db.delete(_db.diaries)..where((t) => t.id.equals(id))).go();
```

### Order By

```dart
final sorted = await (_db.select(_db.diaries)
  ..orderBy([(t) => OrderingTerm.desc(t.date)]))
  .get();
```

### Limit & Offset

```dart
final limited = await (_db.select(_db.diaries)
  ..limit(10, offset: 0))
  .get();
```

---

## 9. Testing Persistence

### On Web (Chrome DevTools)

1. Press **F12**
2. Go to **Application** → **Storage** → **IndexedDB**
3. Look for `notebook_db`
4. Check if data persists after:
   - Page refresh
   - Browser restart

---

## Resources

- [Official Drift Documentation](https://drift.simonbinder.eu/)
- [Drift Web Support](https://drift.simonbinder.eu/web/)
- [GitHub Repository](https://github.com/simolus3/drift)
