import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/common/provider/default_provider_type.dart';
import 'package:pllcare/schedule/repository/schedule_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../common/logger/custom_logger.dart';
import '../../common/model/default_model.dart';
import '../../common/page/param/page_param.dart';
import '../model/schedule_daily_model.dart';
import '../param/schedule_param.dart';

part 'schedule_provider.g.dart';

enum ScheduleProviderType { getCalendar, getOverview, getDaily, create }

class ScheduleProviderParam extends DefaultProviderType {
  final ScheduleProviderType type;

  const ScheduleProviderParam({
    required super.projectId,
    required this.type,
  });

  @override
  List<Object?> get props => [projectId, type];
}

final scheduleOverviewProvider = StateNotifierProvider.family<
    ScheduleOverviewStateNotifier,
    BaseModel,
    ScheduleProviderParam>((ref, type) {
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
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }
}

final scheduleProvider = StateNotifierProvider.autoDispose
    .family<ScheduleStateNotifier, BaseModel, ScheduleProviderParam>(
        (ref, param) {
  final repository = ref.watch(scheduleRepositoryProvider);
  return ScheduleStateNotifier(repository: repository, param: param);
});

class ScheduleStateNotifier extends StateNotifier<BaseModel> {
  final ScheduleRepository repository;
  final ScheduleProviderParam param;

  ScheduleStateNotifier({
    required this.repository,
    required this.param,
  }) : super(LoadingModel()) {
    init();
  }

  void init() {
    switch (param.type) {
      case ScheduleProviderType.getCalendar:
        getCalendar();
        break;
      case ScheduleProviderType.getDaily:
        getDaily();
        break;
      default:
        break;
    }
  }

  Future<void> createSchedule({required ScheduleCreateParam param}) async {
    repository
        .createSchedule(param: param)
        .then((value) => null)
        .catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }

  Future<void> getCalendar() async {
    state = LoadingModel();
    repository.getCalendarSchedule(projectId: param.projectId).then((value) {
      logger.i(value);
      state = value;
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }

  Future<void> getDaily() async {
    state = LoadingModel();
    repository.getScheduleDaily(projectId: param.projectId).then((value) {
      logger.i(value);
      state = value as ListModel<ScheduleDailyModel>;
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }
}

@Riverpod()
class ScheduleFilterFetch extends _$ScheduleFilterFetch {
  @override
  BaseModel build({required ScheduleParams condition}) {
    final PageParams params = PageParams(page: 1, size: 4, direction: 'DESC');
    getFilter(params: params, condition: condition);
    return LoadingModel();
  }

  Future<BaseModel> getFilter(
      {required PageParams params, required ScheduleParams condition}) async {
    state = LoadingModel();
    final repository = ref.watch(scheduleRepositoryProvider);
    return repository
        .getScheduleFilter(param: params, condition: condition)
        .then((value) {
      logger.i(value);
      state = value;
      return state;
    }).catchError((e) {
      logger.e(e);
      state = ErrorModel.respToError(e);
      final error = (state as ErrorModel);
      logger.e('error code ${error.code}, ${error.message}');
      return state;
    });
  }
}
