import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_notebook/core/models/notebook.dart';

class NotebooksViewmodel extends Notifier<AsyncValue<List<NotebookModel>>> {
  @override
  AsyncValue<List<NotebookModel>> build() {
    return const AsyncValue.loading();
  }
}

final notebooksViewmodelProvider = NotifierProvider<NotebooksViewmodel, AsyncValue<List<NotebookModel>>>(() {
  return NotebooksViewmodel();
});