import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/evaluation/param/evaluation_param.dart';
import 'package:pllcare/evaluation/repository/final_eval_repository.dart';

import '../../common/logger/custom_logger.dart';
import '../../common/model/default_model.dart';
import '../../common/provider/default_provider_type.dart';
import 'eval_provider.dart';

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
  return FinalEvalStateNotifier(repository: repository, param: param, ref: ref);
});

class FinalEvalStateNotifier extends StateNotifier<BaseModel> {
  final FinalEvalRepository repository;
  final FinalEvalProviderParam param;
  final StateNotifierProviderRef ref;

  FinalEvalStateNotifier({
    required this.repository,
    required this.param,
    required this.ref,
  }) : super(LoadingModel()) {
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

  Future<BaseModel> createEval({required CreateFinalTermParam param}) async {
    state = LoadingModel();
    return await repository
        .createFinalTerm(param: param)
        .then<BaseModel>((value) {
      logger.i('create final eval!');
      ref
          .read(evalProvider(EvalProviderParam(projectId: param.projectId))
              .notifier)
          .getParticipant();
      return CompletedModel();
    }).catchError((e) {
      final error = ErrorModel.respToError(e);
      logger.e('code = ${error.code}\nmessage = ${error.message}');
      return error;
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
