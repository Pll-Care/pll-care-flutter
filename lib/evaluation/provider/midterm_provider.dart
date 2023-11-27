import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/evaluation/param/evaluation_param.dart';

import '../../common/logger/custom_logger.dart';
import '../../common/model/default_model.dart';
import '../../common/provider/default_provider_type.dart';
import '../repository/mid_eval_repository.dart';

enum MidProviderType { modal, create, getEval, getChart }

class MidEvalProviderParam extends DefaultProviderType {
  final MidProviderType type;
  final int? scheduleId;

  MidEvalProviderParam({
    required super.projectId,
    required this.type,
    this.scheduleId,
  });
}

final midEvalProvider = StateNotifierProvider.autoDispose
    .family<MidEvalStateNotifier, BaseModel, MidEvalProviderParam>(
        (ref, param) {
  final repository = ref.watch(midEvalRepositoryProvider);
  return MidEvalStateNotifier(repository: repository, param: param);
});

class MidEvalStateNotifier extends StateNotifier<BaseModel> {
  final MidEvalProviderParam param;
  final MidEvalRepository repository;

  MidEvalStateNotifier({required this.repository, required this.param})
      : super(LoadingModel()) {
    init();
  }

  void init() {
    switch (param.type) {
      case MidProviderType.modal:
        getModal(scheduleId: param.scheduleId!);
        break;
      case MidProviderType.create:
        break;
      case MidProviderType.getEval:
        getEval();
        break;
      case MidProviderType.getChart:
        getChart();
        break;
    }
  }

  Future<void> getModal({required int scheduleId}) async {
    state = LoadingModel();
    repository
        .getMidTermModal(scheduleId: scheduleId, projectId: param.projectId)
        .then((value) {
      logger.i(value);
      state = value;
    }).catchError((e) {
      logger.e(e);
      state = ErrorModel.respToError(e);
    });
  }

  Future<void> createEval({required CreateMidTermParam param}) async {
    state = LoadingModel();
    repository.createMidTerm(param: param).then((value) {
      logger.i('create mid eval!');
    }).catchError((e) {
      logger.e(e);
      state = ErrorModel.respToError(e);
    });
  }

  Future<void> getEval() async {
    state = LoadingModel();
    repository.getMidTerm(projectId: param.projectId).then((value) {
      logger.i(value);
    }).catchError((e) {
      logger.e(e);
      state = ErrorModel.respToError(e);
    });
  }

  Future<void> getChart() async {
    state = LoadingModel();
    repository.getMidTermChart(projectId: param.projectId).then((value) {
      logger.i(value);
    }).catchError((e) {
      logger.e(e);
      state = ErrorModel.respToError(e);
    });
  }
}
