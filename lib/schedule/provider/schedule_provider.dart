import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/common/provider/default_provider_type.dart';
import 'package:pllcare/schedule/repository/schedule_repository.dart';

import '../../common/logger/custom_logger.dart';
import '../../common/model/default_model.dart';

class ScheduleProviderParam extends DefaultProviderType {
  ScheduleProviderParam({
    required super.projectId,
  });
}

final scheduleOverviewProvider =
    StateNotifierProvider.family<ScheduleOverviewStateNotifier, BaseModel, ScheduleProviderParam>(
        (ref, type) {
  final repository = ref.watch(scheduleRepositoryProvider);
  return ScheduleOverviewStateNotifier(
      repository: repository, projectId: type.projectId);
});

class ScheduleOverviewStateNotifier extends StateNotifier<BaseModel> {
  final ScheduleRepository repository;
  final int projectId;

  ScheduleOverviewStateNotifier({
    required this.repository,
    required this.projectId,
  }) : super(LoadingModel()) {
    getOverview(projectId: projectId);
  }

  Future<void> getOverview({required int projectId}) async {
    state = LoadingModel();
    repository.getScheduleOverview(projectId: projectId).then((value) {
      logger.i(value);
      state = value;
    }).catchError((e) {
      logger.e(e);
      state = ErrorModel.respToError(e);
    });
  }
}
