import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/management/model/team_member_model.dart';
import 'package:pllcare/management/param/management_param.dart';
import 'package:pllcare/management/repository/management_repository.dart';

import '../../common/logger/custom_logger.dart';
import '../../common/model/default_model.dart';
import '../model/apply_model.dart';

class ManageParam {
  final int projectId;
  final bool isManagement;

  ManageParam({
    required this.projectId,
    required this.isManagement,
  });
}

final managementProvider =
    StateNotifierProvider.family.autoDispose<ManagementStateNotifier, BaseModel, int>(
        (ref, projectId) {
  final repository = ref.watch(managementRepositoryProvider);
  return ManagementStateNotifier(
      repository: repository,
      manageParam: ManageParam(projectId: projectId, isManagement: true));
});

final applyListProvider =
    StateNotifierProvider.family.autoDispose<ManagementStateNotifier, BaseModel, int>(
        (ref, projectId) {
  final repository = ref.watch(managementRepositoryProvider);
  return ManagementStateNotifier(
      repository: repository,
      manageParam: ManageParam(projectId: projectId, isManagement: false));
});

final applyProvider =
    StateNotifierProvider<ApplyStateNotifier, BaseModel>((ref) {
  final repository = ref.watch(managementRepositoryProvider);
  return ApplyStateNotifier(repository: repository);
});

class ManagementStateNotifier extends StateNotifier<BaseModel> {
  final ManageParam manageParam;
  final ManagementRepository repository;

  ManagementStateNotifier({
    required this.repository,
    required this.manageParam,
  }) : super(LoadingModel()) {
    manageParam.isManagement ? getMemberList() : getApplyList();
  }

  Future<BaseModel> getMemberList() async {
    state = LoadingModel();
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
    state = LoadingModel();
    return await repository.getApplyList(projectId: manageParam.projectId).then<BaseModel>((value) {
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

  ApplyStateNotifier({
    required this.repository,
  }) : super(LoadingModel());

  Future<void> applyAccept(
      {required int projectId, required ApplyParam param}) async {
    state = LoadingModel();
    repository.applyAccept(projectId: projectId, param: param).then((value) {
      logger.i('apply accept');
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }

  Future<void> applyReject(
      {required int projectId, required ApplyParam param}) async {
    state = LoadingModel();
    repository.applyReject(projectId: projectId, param: param).then((value) {
      logger.i('apply reject');
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }
}
