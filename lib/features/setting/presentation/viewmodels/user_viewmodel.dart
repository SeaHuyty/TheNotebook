import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_notebook/core/models/user.dart';

class UserViewmodel extends Notifier<AsyncValue<UserModel>> {
  @override
  AsyncValue<UserModel> build() {
    return const AsyncValue.loading();
  }
}

final userViewmodelProvider = NotifierProvider<UserViewmodel, AsyncValue<UserModel>>(() {
  return UserViewmodel();
});