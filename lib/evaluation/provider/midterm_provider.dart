import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/evaluation/param/evaluation_param.dart';

import '../../common/logger/custom_logger.dart';
import '../../common/model/default_model.dart';
import '../../common/provider/default_provider_type.dart';
import '../model/midterm_model.dart';
import '../repository/mid_eval_repository.dart';

enum MidProviderType { modal, create, getEval, getChart }

final badgeProvider = StateProvider.autoDispose<BadgeType>((ref) => BadgeType.PASSIONATE);

class MidEvalProviderParam extends DefaultProviderType {
  final MidProviderType type;
  final int? scheduleId;

  const MidEvalProviderParam({
    required super.projectId,
    required this.type,
    this.scheduleId,
  });

  @override
  List<Object?> get props => [projectId, type, scheduleId];
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
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }

  Future<void> createEval({required CreateMidTermParam param}) async {
    state = LoadingModel();
    repository.createMidTerm(param: param).then((value) {
      logger.i('create mid eval!');
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }

  Future<void> getEval() async {
    state = LoadingModel();
    repository.getMidTerm(projectId: param.projectId).then((value) {
      logger.i(value);
      state = ListModel<BadgeModel>(data: value);
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }

  Future<void> getChart() async {
    state = LoadingModel();
    repository.getMidTermChart(projectId: param.projectId).then((value) {
      logger.i(value);
      state = value;
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }
}
