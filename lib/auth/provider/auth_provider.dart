import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:pllcare/auth/model/auth_model.dart';
import 'package:pllcare/auth/param/auth_param.dart';
import 'package:pllcare/auth/repository/auth_repository.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/common/provider/secure_storage_provider.dart';

import '../../common/logger/custom_logger.dart';

final authProvider = StateNotifierProvider<AuthStateNotifier, AuthModel?>(
    (StateNotifierProviderRef<AuthStateNotifier, AuthModel?> ref) {
  final repository = ref.watch(authRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);
  return AuthStateNotifier(
    repository: repository,
    storage: storage,
    ref:ref,
  );
});

class AuthStateNotifier extends StateNotifier<AuthModel?> {
  final AuthRepository repository;
  final FlutterSecureStorage storage;
  final StateNotifierProviderRef<AuthStateNotifier, AuthModel?> ref;

  AuthStateNotifier({
    required this.repository,
    required this.storage,
    required this. ref,
  }) : super(null);

  Future<void> signUp({required AuthParameter param}) async {
    state = await repository.signUp(param: param);
    await storage.write(key: 'accessToken', value: state!.accessToken);
    await storage.write(key: 'refreshToken', value: state!.refreshToken);
  }

  Future<void> reIssueToken() async {
    state = await repository.getReIssueToken();
    await storage.write(key: 'accessToken', value: state!.accessToken);
    await storage.write(key: 'refreshToken', value: state!.refreshToken);
  }

  Future<void> autoLogin() async{
    final storage = ref.read(secureStorageProvider);
    final accessToken = await storage.read(key: 'accessToken');
    final refreshToken = await storage.read(key: 'refreshToken');
    state = AuthModel(accessToken: accessToken, refreshToken: refreshToken);
  }

  Future<void> logout() async {
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
  }) : super(LoadingModel()) {
    getProfileImage();
  }

  Future<bool> getProfileImage() async {
    return await repository.getProfile().then((value) {
      logger.i(value);
      state = value;
      return true;
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');

      return false;
    });
  }
}
