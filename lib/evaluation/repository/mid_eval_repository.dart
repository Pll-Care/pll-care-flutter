import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/dio/dio_interceptor.dart';
import 'package:pllcare/dio/provider/dio_provider.dart';
import 'package:pllcare/evaluation/model/chart_rank_model.dart';
import 'package:retrofit/http.dart';

import '../model/midterm_model.dart';
import '../param/evaluation_param.dart';

part 'mid_eval_repository.g.dart';

final midEvalRepositoryProvider = Provider<MidEvalRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return MidEvalRepository(dio);
});

@RestApi(baseUrl: serverURL)
abstract class MidEvalRepository {
  factory MidEvalRepository(Dio dio) = _MidEvalRepository;

  @GET('/api/auth/evaluation/midterm')
  @Headers({
    'token': 'true',
  })
  Future<MidTermModel> getMidTermModal({
    @Query('scheduleId') required int scheduleId,
    @Query('projectId') required int projectId,
  });

  @POST('/api/auth/evaluation/midterm')
  @Headers({
    'token': 'true',
  })
  Future<void> createMidTerm({
    @Body() required CreateMidTermParam param,
  });

  @GET('/api/auth/evaluation/midtermlist')
  @Headers({
    'token': 'true',
  })
  Future<ChartRankModel<ChartBadgeModel, MidTermRankModel>> getMidTermChart({
    @Query('project_id') required int projectId,
  });

  @GET('/api/auth/evaluation/midterm/detail')
  @Headers({
    'token': 'true',
  })
  Future<List<BadgeModel>> getMidTerm({
    @Query('project_id') required int projectId,
  });


}
