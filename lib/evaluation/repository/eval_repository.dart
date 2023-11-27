import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/dio/dio_interceptor.dart';
import 'package:pllcare/dio/provider/dio_provider.dart';
import 'package:pllcare/evaluation/model/chart_rank_model.dart';
import 'package:pllcare/evaluation/model/participant_model.dart';
import 'package:retrofit/http.dart';

import '../model/finalterm_model.dart';
import '../model/midterm_model.dart';
import '../param/evaluation_param.dart';

part 'eval_repository.g.dart';

final evalRepositoryProvider = Provider<EvalRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return EvalRepository(dio);
});

@RestApi(baseUrl: serverURL)
abstract class EvalRepository {
  factory EvalRepository(Dio dio) = _EvalRepository;

  @GET('/api/auth/evaluation/participant')
  @Headers({
    'token': 'true',
  })
  Future<List<ParticipantModel>> getParticipant({
    @Query('project_id') required int projectId,
  });
}
