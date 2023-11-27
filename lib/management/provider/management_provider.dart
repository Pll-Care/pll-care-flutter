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
    StateNotifierProvider.family<ManagementStateNotifier, BaseModel, int>(
        (ref, projectId) {
  final repository = ref.watch(managementRepositoryProvider);
  return ManagementStateNotifier(repository: repository, manageParam: ManageParam(projectId: projectId, isManagement: true));
});

final applyListProvider =
    StateNotifierProvider.family<ManagementStateNotifier, BaseModel, int>(
        (ref, projectId) {
  final repository = ref.watch(managementRepositoryProvider);
  return ManagementStateNotifier(repository: repository, manageParam:  ManageParam(projectId: projectId, isManagement: false));
});

final applyProvider = StateNotifierProvider<ApplyStateNotifier, BaseModel>((ref) {
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

  Future<void> getMemberList() async {
    state = LoadingModel();
    repository.getMemberList(projectId: manageParam.projectId).then((value) {
      logger.i(value);
      state = ListModel<TeamMemberModel>(data: value);
    }).catchError((e) {
      logger.e(e);
      state = ErrorModel.respToError(e);
    });
  }

  Future<void> getApplyList() async {
    state = LoadingModel();
    repository.getApplyList(projectId: manageParam.projectId).then((value) {
      logger.i(value);
      state = ListModel<ApplyModel>(data: value);
    }).catchError((e) {
      logger.e(e);
      state = ErrorModel.respToError(e);
    });
  }
}



class ApplyStateNotifier extends StateNotifier<BaseModel> {
  final ManagementRepository repository;

  ApplyStateNotifier({
    required this.repository,
  }) : super(LoadingModel()) ;

  Future<void> applyAccept({required int projectId, required ApplyParam param}) async {
    state = LoadingModel();
    repository.applyAccept(projectId: projectId, param: param).then((value) {
      logger.i('apply accept');
    }).catchError((e) {
      logger.e(e);
      state = ErrorModel.respToError(e);
    });
  }

  Future<void> applyReject({required int projectId, required ApplyParam param}) async {
    state = LoadingModel();
    repository.applyReject(projectId: projectId, param: param).then((value) {
      logger.i('apply reject');
    }).catchError((e) {
      logger.e(e);
      state = ErrorModel.respToError(e);
    });
  }
}