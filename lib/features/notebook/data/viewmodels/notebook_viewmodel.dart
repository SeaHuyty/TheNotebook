import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_notebook/core/models/notebook.dart';

class NotebookViewmodel extends Notifier<AsyncValue<NotebookModel>> {
  @override
  AsyncValue<NotebookModel> build() {
    return const AsyncValue.loading();
  }
}

final notebookViewmodelProvider = NotifierProvider<NotebookViewmodel, AsyncValue<NotebookModel>>(() {
  return NotebookViewmodel();
});