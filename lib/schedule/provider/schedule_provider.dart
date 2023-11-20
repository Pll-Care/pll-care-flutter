import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/schedule/repository/schedule_repository.dart';

import '../../common/logger/custom_logger.dart';
import '../../common/model/default_model.dart';

final scheduleOverviewProvider =
    StateNotifierProvider.family<ScheduleOverviewStateNotifier, BaseModel, int>(
        (ref, projectId) {
  final repository = ref.watch(scheduleRepositoryProvider);
  return ScheduleOverviewStateNotifier(repository: repository, projectId:  projectId);
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
