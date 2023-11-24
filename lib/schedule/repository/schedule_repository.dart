import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/dio/dio_interceptor.dart' ;
import 'package:pllcare/dio/provider/dio_provider.dart';
import 'package:pllcare/schedule/model/schedule_calendar_model.dart';
import 'package:retrofit/http.dart';

import '../model/schedule_daily_model.dart';
import '../model/schedule_filter_model.dart';
import '../model/schedule_overview_model.dart';

part 'schedule_repository.g.dart';

final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ScheduleRepository(dio);
});

@RestApi(baseUrl: serverURL)
abstract class ScheduleRepository {
  factory ScheduleRepository(Dio dio) = _ScheduleRepository;

  @GET('/api/auth/schedule/list')
  @Headers({
    'token': 'true',
  })
  Future<ScheduleOverViewModel> getScheduleOverview(
      {@Query('project_id') required int projectId});

  @GET('/api/auth/schedule/calendarlist')
  @Headers({
    'token': 'true',
  })
  Future<CalendarScheduleModel> getCalendarSchedule(
      {@Query('project_id') required int projectId});

  @GET('/api/auth/schedule/daily')
  @Headers({
    'token': 'true',
  })
  Future<List<ScheduleDailyModel>> getScheduleDaily(
      {@Query('project_id') required int projectId});

  @GET('/api/auth/schedule/search')
  @Headers({
    'token': 'true',
  })
  Future<ScheduleFilterList> getScheduleFilter(
      {@Query('project_id') required int projectId});
}
