import 'package:drift/drift.dart';
import 'package:flutter/painting.dart';
import 'package:the_notebook/core/database/database.dart';
import 'package:the_notebook/features/notebook/model/notebook.dart' as domain;

class NotebookRepository {
  final AppDatabase _db = AppDatabase();

  NotebookRepository();

  Future<List<domain.Notebook>> getNotebooks() async {
    final notebooks = await _db.select(_db.notebooks).get();

    return notebooks
        .map(
          (n) => domain.Notebook(
            id: n.id,
            title: n.title,
            icon: n.icon,
            color: n.color != null ? Color(n.color!) : null,
          ),
        )
        .toList();
  }

  Future<int> insertNotebook(domain.Notebook notebook) {
    return _db.into(_db.notebooks).insert(
          NotebooksCompanion(
            title: Value(notebook.title),
            icon: Value(notebook.icon),
            color: Value(notebook.color?.toARGB32()),
          ),
        );
  }

  Future<void> updateNotebook(domain.Notebook notebook) {
    return (_db.update(_db.notebooks)..where((n) => n.id.equals(notebook.id!)))
        .write(
      NotebooksCompanion(
        title: Value(notebook.title),
        icon: Value(notebook.icon),
        color: Value(notebook.color?.toARGB32()),
      ),
    );
  }

  Future<void> deleteNotebook(int id) {
    return (_db.delete(_db.notebooks)..where((n) => n.id.equals(id))).go();
  }

  void dispose() {
    _db.close();
  }
}
