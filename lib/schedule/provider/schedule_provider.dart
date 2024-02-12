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

enum ScheduleProviderType {
  getCalendar,
  getOverview,
  getDaily,
  create,
  update,
  updateState,
  getSchedule,
  delete,
}

class ScheduleProviderParam extends DefaultProviderType {
  final ScheduleProviderType type;
  final int? scheduleId;

  const ScheduleProviderParam({
    required super.projectId,
    required this.type,
    this.scheduleId,
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
      case ScheduleProviderType.getSchedule:
        getSchedule();
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

  Future<void> updateSchedule({required ScheduleUpdateParam param}) async {
    repository
        .updateSchedule(param: param, scheduleId: this.param.scheduleId!)
        .then((value) => null)
        .catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }

  Future<void> updateState({required ScheduleStateUpdateParam param}) async {
    repository
        .updateScheduleState(scheduleId: this.param.scheduleId!, param: param)
        .then((value) => null)
        .catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }

  Future<void> getSchedule() async {
    state = LoadingModel();
    repository
        .getSchedule(scheduleId: param.scheduleId!, projectId: param.projectId)
        .then((value) {
      logger.i(value);
      state = value;
    }).catchError((e) {
      state = ErrorModel.respToError(e);
      final error = state as ErrorModel;
      logger.e('code = ${error.code}\nmessage = ${error.message}');
    });
  }

  Future<void> deleteSchedule() async {
    repository
        .deleteSchedule(
            scheduleId: param.scheduleId!,
            projectId: ScheduleDeleteParam(projectId: param.projectId))
        .then((value) {
      logger.i('schedule delete!');
    }).catchError((e) {
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
    final PageParams params = defaultPageParam;
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
