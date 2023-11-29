import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pllcare/auth/model/auth_model.dart';
import 'package:pllcare/auth/param/auth_param.dart';
import 'package:pllcare/auth/repository/auth_repository.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/common/provider/secure_storage_provider.dart';

import '../../common/logger/custom_logger.dart';

final authProvider =
    StateNotifierProvider<AuthStateNotifier, AuthModel?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);
  return AuthStateNotifier(repository: repository, storage: storage);
});

class AuthStateNotifier extends StateNotifier<AuthModel?> {
  final AuthRepository repository;
  final FlutterSecureStorage storage;

  AuthStateNotifier({
    required this.repository,
    required this.storage,
  }) : super(null);

  Future<void> signUp({required AuthParameter param}) async {
    state = await repository.signUp(param: param);
    await storage.write(key: 'accessToken', value: state!.accessToken);
    await storage.write(key: 'refreshToken', value: state!.refreshToken);
  }

  void logout() async {
    state = null;
    await storage.deleteAll();
  }
}

final memberProvider = StateNotifierProvider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return MemberStateNotifier(repository: repository);
});

class MemberStateNotifier extends StateNotifier<BaseModel> {
  final AuthRepository repository;

  MemberStateNotifier({
    required this.repository,
  }) : super(LoadingModel());

  Future<void> getProfileImage() async {
    await repository.getProfile().then((value) {
      logger.i(value);
      state = value;
    }).catchError((e) {
      logger.e(e);
      state = ErrorModel.respToError(e);
    });
  }
}
