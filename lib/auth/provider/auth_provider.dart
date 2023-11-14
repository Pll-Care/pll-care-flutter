import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pllcare/auth/model/auth_model.dart';
import 'package:pllcare/auth/param/auth_param.dart';
import 'package:pllcare/auth/repository/auth_repository.dart';
import 'package:pllcare/common/provider/secure_storage_provider.dart';

final authProvider = StateNotifierProvider<AuthStateNotifier, AuthModel>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);
  return AuthStateNotifier(repository: repository, storage: storage);
});

class AuthStateNotifier extends StateNotifier<AuthModel> {
  final AuthRepository repository;
  final FlutterSecureStorage storage;

  AuthStateNotifier({
    required this.repository,
    required this.storage,
  }) : super(AuthModel(
          accessToken: '',
          refreshToken: '',
        ));

  Future<void> signUp({required AuthParameter param}) async {
    final response = await repository.signUp(param: param);
    await storage.write(key: 'accessToken', value: response.accessToken);
    await storage.write(key: 'refreshToken', value: response.refreshToken);
  }
}
