import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_notebook/core/models/diary.dart';

class DiaryViewmodel extends Notifier<AsyncValue<DiaryModel>> {
  @override
  AsyncValue<DiaryModel> build() {
    return const AsyncValue.loading();
  }
}

final diaryViewmodelProvider = NotifierProvider<DiaryViewmodel, AsyncValue<DiaryModel>>(() {
  return DiaryViewmodel();
});