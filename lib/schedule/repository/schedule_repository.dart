import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/dio/dio_interceptor.dart' ;
import 'package:pllcare/dio/provider/dio_provider.dart';
import 'package:retrofit/http.dart';

import '../model/schedule_model.dart';

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
  Future<ScheduleModel> getScheduleOverview(
      {@Query('project_id') required int projectId});
}
