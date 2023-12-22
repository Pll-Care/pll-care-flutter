import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/evaluation/param/evaluation_param.dart';
import 'package:pllcare/evaluation/repository/final_eval_repository.dart';

import '../../common/logger/custom_logger.dart';
import '../../common/model/default_model.dart';
import '../../common/provider/default_provider_type.dart';

enum FinalProviderType { create, getEval, getChart }

class FinalEvalProviderParam extends DefaultProviderType {
  final FinalProviderType type;
  final int? evaluationId;

  const FinalEvalProviderParam({
    required super.projectId,
    required this.type,
    this.evaluationId,
  });
  @override
  List<Object?> get props => [projectId, type, evaluationId];
}

final finalEvalProvider = StateNotifierProvider.autoDispose
    .family<FinalEvalStateNotifier, BaseModel, FinalEvalProviderParam>(
        (ref, param) {
  final repository = ref.watch(finalEvalRepositoryProvider);
  return FinalEvalStateNotifier(repository: repository, param: param);
});

class FinalEvalStateNotifier extends StateNotifier<BaseModel> {
  final FinalEvalRepository repository;
  final FinalEvalProviderParam param;

  FinalEvalStateNotifier({required this.repository, required this.param})
      : super(LoadingModel()) {
    init();
  }

  void init() {
    switch (param.type) {
      case FinalProviderType.create:
        break;
      case FinalProviderType.getEval:
        getEval(evaluationId: param.evaluationId!);
        break;
      case FinalProviderType.getChart:
        getChart();
        break;
    }
  }

  Future<void> createEval({required CreateFinalTermParam param}) async {
    state = LoadingModel();
    repository.createFinalTerm(param: param).then((value) {
      logger.i('create final eval!');
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }

  Future<void> getEval({required int evaluationId}) async {
    state = LoadingModel();
    repository
        .getFinalTerm(projectId: param.projectId, evaluationId: evaluationId)
        .then((value) {
      logger.i(value);
      state = value;
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }

  Future<void> getChart() async {
    state = LoadingModel();
    repository.getFinalTermChart(projectId: param.projectId).then((value) {
      logger.i(value);
      state = value;
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }
}
