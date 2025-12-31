import 'package:drift/drift.dart';
import 'package:the_notebook/core/database/database.dart';
import 'package:the_notebook/features/notebook/data/seed_notebook_data.dart';
import 'package:the_notebook/features/notebook/model/notebook.dart' as domain;

class NotebookRepository {
  final AppDatabase _db = AppDatabase();

  NotebookRepository();

  // Convert int to enum
  domain.NotebookType _intToCategory(int i) => domain.NotebookType.values[i];

  // Convert enum to int
  int _categoryToInt(domain.NotebookType category) => category.index;

  Future<void> seedIfEmpty() async {
    final existing = await _db.select(_db.notebooks).get();
    if (existing.isNotEmpty) return;

    for (var entry in notebookList) {
      await insertNotebook(entry);
    }
  }

  Future<List<domain.Notebook>> getNotebooks() async {
    final notebooks = await _db.select(_db.notebooks).get();

    return notebooks
        .map(
          (n) => domain.Notebook(
            id: n.id,
            title: n.title,
            category: _intToCategory(n.category),
          ),
        )
        .toList();
  }

  Future<int> insertNotebook(domain.Notebook notebook) {
    return _db.into(_db.notebooks).insert(
          NotebooksCompanion(
            title: Value(notebook.title),
            category: Value(_categoryToInt(notebook.category)),
          ),
        );
  }

  Future<void> updateNotebook(domain.Notebook notebook) {
    return (_db.update(_db.notebooks)
          ..where((n) => n.id.equals(notebook.id!)))
        .write(
      NotebooksCompanion(
        title: Value(notebook.title),
        category: Value(_categoryToInt(notebook.category)),
      ),
    );
  }

  Future<void> deleteNotebook(int id) {
    return (_db.delete(_db.notebooks)
          ..where((n) => n.id.equals(id)))
        .go();
  }

  void dispose() {
    _db.close();
  }
}
