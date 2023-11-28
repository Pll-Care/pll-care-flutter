import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/common/provider/default_provider_type.dart';
import 'package:pllcare/evaluation/model/participant_model.dart';

import '../../common/logger/custom_logger.dart';
import '../../common/model/default_model.dart';
import '../repository/eval_repository.dart';

class EvalProviderParam extends DefaultProviderType {
  const EvalProviderParam({required super.projectId});

}

final evalProvider = StateNotifierProvider.family
    .autoDispose<EvalStateNotifier, BaseModel, EvalProviderParam>((ref, type) {
  final repository = ref.watch(evalRepositoryProvider);
  return EvalStateNotifier(repository: repository, projectId: type.projectId);
});

class EvalStateNotifier extends StateNotifier<BaseModel> {
  final EvalRepository repository;
  final int projectId;

  EvalStateNotifier({
    required this.repository,
    required this.projectId,
  }) : super(LoadingModel()) {
    getParticipant();
  }

  Future<void> getParticipant() async {
    state = LoadingModel();
    repository.getParticipant(projectId: projectId).then((value) {
      logger.i(value);
      state = ListModel<ParticipantModel>(data: value);
    }).catchError((e) {
      logger.e(e);
      state = ErrorModel.respToError(e);
    });
  }
}
