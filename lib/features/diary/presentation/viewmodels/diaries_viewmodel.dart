import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_notebook/core/models/diary.dart';

class DiariesViewmodel extends Notifier<AsyncValue<List<DiaryModel>>> {
  @override
  AsyncValue<List<DiaryModel>> build() {
    return const AsyncValue.loading();
  }
}

final diariesViewmodelProvider = NotifierProvider<DiariesViewmodel, AsyncValue<List<DiaryModel>>>(() {
  return DiariesViewmodel();
});