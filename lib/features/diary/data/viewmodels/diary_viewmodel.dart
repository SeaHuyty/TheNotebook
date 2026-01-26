import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_notebook/core/models/diary.dart';
import 'package:the_notebook/features/diary/data/repositories/diary_repository.dart';

class DiaryViewmodel extends Notifier<AsyncValue<DiaryModel>> {
  @override
  AsyncValue<DiaryModel> build() {
    return const AsyncValue.loading();
  }

  Future<void> loadDiaryById(int diaryId) async {
    state = AsyncValue.loading();
    try {
      final diary = await ref.read(diaryRepositoryProvider).getDiaryById(diaryId);
      state = AsyncValue.data(diary!);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final diaryViewmodelProvider = NotifierProvider<DiaryViewmodel, AsyncValue<DiaryModel>>(() {
  return DiaryViewmodel();
});