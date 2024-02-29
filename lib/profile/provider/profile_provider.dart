import 'dart:developer';

import 'package:pllcare/common/page/param/page_param.dart';
import 'package:pllcare/profile/model/profile_eval_chart_model.dart';
import 'package:pllcare/profile/repository/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../common/logger/custom_logger.dart';
import '../../common/model/default_model.dart';
import '../model/profile_apply_model.dart';
import '../model/profile_eval_model.dart';
import '../model/profile_model.dart';
import '../model/project_experience_model.dart';
import '../param/profile_param.dart';

part 'profile_provider.g.dart';

@riverpod
Future<BaseModel> profileEdit(ProfileEditRef ref,
    {required int memberId, required PatchProfileParam param}) async {
  return await ref
      .watch(userRepositoryProvider)
      .patchProfile(memberId: memberId, param: param)
      .then<BaseModel>((value) {
    logger.i('change profile!');
    return CompletedModel();
  }).catchError((e) {
    final error = ErrorModel.respToError(e);
    logger.e('code = ${error.code}\nmessage = ${error.message}');
    return error;
  });
}

@Riverpod(keepAlive: true)
Future<ContactModel> profileContact(ProfileContactRef ref, {required int memberId}){
  return ref.watch(userRepositoryProvider).getProfileContact(memberId: memberId);
}

@Riverpod(keepAlive: true)
Future<ProjectExperienceList> profileExperience(ProfileExperienceRef ref, {required int memberId}){
  return ref.watch(userRepositoryProvider).getProjectExperience(memberId: memberId);
}

@Riverpod(keepAlive: true)
Future<RoleTechStackModel> profileRoleTechStack(ProfileRoleTechStackRef ref, {required int memberId}){
  return ref.watch(userRepositoryProvider).getRoleTechStack(memberId: memberId);
}

@Riverpod(keepAlive: true)
class ProfileIntro extends _$ProfileIntro {
  @override
  BaseModel build({required int memberId}) {
    getProfileIntro(memberId: memberId);
    return LoadingModel();
  }

  Future<void> getProfileIntro({required int memberId}) async {
    ref
        .read(userRepositoryProvider)
        .getProfileIntro(memberId: memberId)
        .then((value) {
      logger.i(value);
      state = value;
    }).catchError((e) {
      final error = ErrorModel.respToError(e);
      logger.e('code = ${error.code}\nmessage = ${error.message}');
      state = error;
    });
  }
}

enum ProfileProviderType { apply, recruit, favorite }

@riverpod
class ProfilePost extends _$ProfilePost {
  @override
  BaseModel build({required int memberId, required ProfileProviderType type}) {
    switch (type) {
      case ProfileProviderType.apply:
        getApplyPost(memberId: memberId, param: defaultPageParam);
        break;
      case ProfileProviderType.recruit:
        getRecruitPost(
            memberId: memberId,
            param: defaultPageParam,
            stateType: StateType.ONGOING);
        break;
      case ProfileProviderType.favorite:
        getLikePost(memberId: memberId, param: defaultPageParam);
        break;
    }
    return LoadingModel();
  }

  Future<void> getApplyPost(
      {required int memberId, required PageParams param}) async {
    ref
        .read(userRepositoryProvider)
        .getProfileApplyList(memberId: memberId, param: param)
        .then((value) {
      logger.i(value);
      state = value;
    }).catchError((e) {
      final error = ErrorModel.respToError(e);
      logger.e('code = ${error.code}\nmessage = ${error.message}');
      state = error;
    });
  }

  Future<void> getRecruitPost(
      {required int memberId,
      required PageParams param,
      required StateType stateType}) async {
    ref
        .read(userRepositoryProvider)
        .getPost(memberId: memberId, param: param, state: stateType)
        .then((value) {
      logger.i(value);
      state = value;
    }).catchError((e) {
      final error = ErrorModel.respToError(e);
      logger.e('code = ${error.code}\nmessage = ${error.message}');
      state = error;
    });
  }

  Future<void> getLikePost(
      {required int memberId, required PageParams param}) async {
    ref
        .read(userRepositoryProvider)
        .getPostLike(memberId: memberId, param: param)
        .then((value) {
      logger.i(value);
      state = value;
    }).catchError((e) {
      final error = ErrorModel.respToError(e);
      logger.e('code = ${error.code}\nmessage = ${error.message}');
      state = error;
    });
  }

  void applyCancel({required int postId}) {
    final applyState = state as ProfileApplyList;
    log('(state as ProfileApplyList).data!.length = ${(state as ProfileApplyList).data!.length}');
    applyState.data!.removeWhere((e) => e.postId == postId);
    state = applyState.copyWith();
    log('(state as ProfileApplyList).data!.length = ${(state as ProfileApplyList).data!.length}');
  }
}

@riverpod
Future<ProfileEvalList> profileEvalList(ProfileEvalListRef ref,
    {required int memberId, required PageParams param}) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getProfileEvalList(memberId: memberId, param: param);
}

@riverpod
Future<ProfileEvalModel> profileEval(ProfileEvalRef ref,
    {required int memberId, required int projectId}) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getProfileEval(memberId: memberId, projectId: projectId);
}

@riverpod
Future<ProfileEvalChartModel> profileEvalChart(ProfileEvalChartRef ref,
    {required int memberId}) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getProfileEvalChart(memberId: memberId);
}
