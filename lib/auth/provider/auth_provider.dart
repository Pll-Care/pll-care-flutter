import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:pllcare/auth/model/auth_model.dart';
import 'package:pllcare/auth/param/auth_param.dart';
import 'package:pllcare/auth/repository/auth_repository.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/common/provider/secure_storage_provider.dart';

import '../../common/logger/custom_logger.dart';

final tokenProvider = ChangeNotifierProvider<TokenProvider>((ref) {
  return TokenProvider(ref: ref);
});

class TokenProvider extends ChangeNotifier {
  final Ref ref;

  TokenProvider({
    required this.ref,
  }) {
    ref.listen(authProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  Future<void> logout() async {
    await ref.read(authProvider.notifier).logout();
  }

  String? redirectLogic(GoRouterState goRouteState) {
    log('redirect start!');
    final tokens = ref.read(authProvider);
    final loginIn = goRouteState.path == '/login';

    // 유저 정보가 없는데
    // 로그인중이면 그대로 로그인 페이지에 두고
    // 만약에 로그인중이 아니라면 로그인 페이지로 이동
    if (tokens == null) {
      log("로그인으로 redirect!!");
      return loginIn ? null : '/home';
    }

    if (loginIn) {
      log("로그인 된 사용자 홀로 이동 !!");
      return '/home';
    }
    return null;
  }
}

final authProvider = StateNotifierProvider<AuthStateNotifier, AuthModel?>(
    (StateNotifierProviderRef<AuthStateNotifier, AuthModel?> ref) {
  final repository = ref.watch(authRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);
  return AuthStateNotifier(
    repository: repository,
    storage: storage,
    ref: ref,
  );
});

class AuthStateNotifier extends StateNotifier<AuthModel?> {
  final AuthRepository repository;
  final FlutterSecureStorage storage;
  final StateNotifierProviderRef<AuthStateNotifier, AuthModel?> ref;

  AuthStateNotifier({
    required this.repository,
    required this.storage,
    required this.ref,
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

  Future<void> autoLogin() async {
    final storage = ref.read(secureStorageProvider);
    final accessToken = await storage.read(key: 'accessToken');
    final refreshToken = await storage.read(key: 'refreshToken');
    state = AuthModel(accessToken: accessToken, refreshToken: refreshToken);
  }

  Future<void> logout() async {
    state = null;
    await storage.deleteAll();
  }

  String? redirectLogic(GoRouterState goRouteState) {
    log('redirect start!');
    final logginIn = goRouteState.path == '/login';

    // 유저 정보가 없는데
    // 로그인중이면 그대로 로그인 페이지에 두고
    // 만약에 로그인중이 아니라면 로그인 페이지로 이동
    if (state == null) {
      log("로그인으로 redirect!!");
      return logginIn ? null : '/home';
    }

    if (logginIn) {
      log("로그인 된 사용자 홀로 이동 !!");
      return '/home';
    }
    return null;
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
