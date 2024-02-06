import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/management/model/team_member_model.dart';
import 'package:pllcare/management/param/management_param.dart';
import 'package:pllcare/management/repository/management_repository.dart';
import 'package:pllcare/project/provider/project_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../common/logger/custom_logger.dart';
import '../../common/model/default_model.dart';
import '../model/apply_model.dart';

part 'management_provider.g.dart';

class ManageParam {
  final int projectId;
  final bool isManagement;

  ManageParam({
    required this.projectId,
    required this.isManagement,
  });
}

@riverpod
Future<BaseModel> changePosition(ChangePositionRef ref,
    {required int projectId, required ChangePositionParam param}) async {
  final repository = ref.watch(managementRepositoryProvider);
  return await repository
      .changePosition(projectId: projectId, param: param)
      .then<BaseModel>((value) {
    logger.i('change position ${param.position.name}!');
    ref.read(managementProvider(projectId).notifier).getMemberList();
    return CompletedModel();
  }).catchError((e) {
    final error = ErrorModel.respToError(e);
    logger.e('code = ${error.code}\nmessage = ${error.message}');
    return error;
  });
}

@riverpod
Future<BaseModel> changeLeader(ChangeLeaderRef ref,
    {required int projectId, required ChangeLeaderParam param}) async {
  final repository = ref.watch(managementRepositoryProvider);
  return await repository
      .changeLeader(projectId: projectId, param: param)
      .then<BaseModel>((value) {
    logger.i('change leader ${param.id}!');
    ref.read(managementProvider(projectId).notifier).getMemberList();
    ref.read(projectLeaderProvider(projectId: projectId).notifier).loseLeader();

    return CompletedModel();
  }).catchError((e) {
    final error = ErrorModel.respToError(e);
    logger.e('code = ${error.code}\nmessage = ${error.message}');
    return error;
  });
}

@riverpod
Future<BaseModel> kickOut(KickOutRef ref,
    {required int projectId, required KickOutParam param}) async {
  final repository = ref.watch(managementRepositoryProvider);
  return await repository
      .kickOut(projectId: projectId, param: param)
      .then<BaseModel>((value) {
    logger.i('kick out ${param.id}!');
    ref.read(managementProvider(projectId).notifier).getMemberList();

    return CompletedModel();
  }).catchError((e) {
    final error = ErrorModel.respToError(e);
    logger.e('code = ${error.code}\nmessage = ${error.message}');
    return error;
  });
}

final managementProvider = StateNotifierProvider.family
    .autoDispose<ManagementStateNotifier, BaseModel, int>((ref, projectId) {
  final repository = ref.watch(managementRepositoryProvider);
  return ManagementStateNotifier(
      repository: repository,
      manageParam: ManageParam(projectId: projectId, isManagement: true),
      ref: ref);
});

final applyListProvider = StateNotifierProvider.family
    .autoDispose<ManagementStateNotifier, BaseModel, int>((ref, projectId) {
  final repository = ref.watch(managementRepositoryProvider);
  return ManagementStateNotifier(
      repository: repository,
      manageParam: ManageParam(projectId: projectId, isManagement: false),
      ref: ref);
});

final applyProvider =
    StateNotifierProvider<ApplyStateNotifier, BaseModel>((ref) {
  final repository = ref.watch(managementRepositoryProvider);
  return ApplyStateNotifier(repository: repository, ref: ref);
});

class ManagementStateNotifier extends StateNotifier<BaseModel> {
  final ManageParam manageParam;
  final ManagementRepository repository;
  final StateNotifierProviderRef ref;

  ManagementStateNotifier({
    required this.repository,
    required this.manageParam,
    required this.ref,
  }) : super(LoadingModel()) {
    manageParam.isManagement ? getMemberList() : getApplyList();
  }

  Future<BaseModel> getMemberList() async {
    return await repository
        .getMemberList(projectId: manageParam.projectId)
        .then((value) {
      logger.i(value);
      state = ListModel<TeamMemberModel>(data: value);
      return state;
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
      return state;
    });
  }

  Future<BaseModel> getApplyList() async {
    // state = LoadingModel();
    return await repository
        .getApplyList(projectId: manageParam.projectId)
        .then<BaseModel>((value) {
      logger.i(value);
      state = ListModel<ApplyModel>(data: value);
      return CompletedModel();
    }).catchError((e) {
      final error = ErrorModel.respToError(e);
      logger.e('code = ${error.code}\nmessage = ${error.message}');
      return error;
    });
  }
}

class ApplyStateNotifier extends StateNotifier<BaseModel> {
  final ManagementRepository repository;
  final StateNotifierProviderRef ref;

  ApplyStateNotifier({
    required this.repository,
    required this.ref,
  }) : super(LoadingModel());

  Future<BaseModel> applyAccept(
      {required int projectId, required ApplyParam param}) async {
    state = LoadingModel();
    return await repository.applyAccept(projectId: projectId, param: param).then<BaseModel>((value) {
      logger.i('apply accept');
      ref
          .read(managementProvider(projectId).notifier)
          .getMemberList();
      ref.read(applyListProvider(projectId).notifier).getApplyList();
      return CompletedModel();
    }).catchError((e) {
      final error = ErrorModel.respToError(e);
      logger.e('code = ${error.code}\nmessage = ${error.message}');
      return error;
    });
  }

  Future<BaseModel> applyReject(
      {required int projectId, required ApplyParam param}) async {
    state = LoadingModel();
    return await repository
        .applyReject(projectId: projectId, param: param)
        .then<BaseModel>((value) {
      logger.i('apply reject');
      ref
          .read(managementProvider(projectId).notifier)
          .getMemberList();
      ref.read(applyListProvider(projectId).notifier).getApplyList();
      return CompletedModel();
    }).catchError((e) {
      final error = ErrorModel.respToError(e);
      logger.e('code = ${error.code}\nmessage = ${error.message}');
      return error;
    });
  }
}
