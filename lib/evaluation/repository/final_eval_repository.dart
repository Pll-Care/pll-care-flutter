import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/dio/dio_interceptor.dart';
import 'package:pllcare/dio/provider/dio_provider.dart';
import 'package:pllcare/evaluation/model/chart_rank_model.dart';
import 'package:retrofit/http.dart';

import '../model/finalterm_model.dart';
import '../param/evaluation_param.dart';

part 'final_eval_repository.g.dart';

final finalEvalRepositoryProvider = Provider<FinalEvalRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return FinalEvalRepository(dio);
});

@RestApi(baseUrl: serverURL)
abstract class FinalEvalRepository {
  factory FinalEvalRepository(Dio dio) = _FinalEvalRepository;


  @POST('/api/auth/evaluation/final')
  @Headers({
    'token': 'true',
  })
  Future<void> createFinalTerm({
    @Body() required CreateFinalTermParam param,
  });

  @GET('/api/auth/evaluation/finallist')
  @Headers({
    'token': 'true',
  })
  Future<FinalChartRankModel<ScoreModel, FinalTermRankModel>> getFinalTermChart({
    @Query('project_id') required int projectId,
  });

  @GET('/api/auth/evaluation/final/{evaluationId}')
  @Headers({
    'token': 'true',
  })
  Future<FinalTermModel> getFinalTerm({
    @Query('project_id') required int projectId,
    @Path('evaluationId') required int evaluationId,
  });
}
