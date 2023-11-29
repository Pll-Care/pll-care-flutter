import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/dio/dio_interceptor.dart';
import 'package:pllcare/dio/provider/dio_provider.dart';
import 'package:pllcare/util/model/techstack_model.dart';
import 'package:retrofit/http.dart';

import '../../auth/model/auth_model.dart';

part 'util_repository.g.dart';

final utilRepositoryProvider = Provider<UtilRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return UtilRepository(dio);
});

@RestApi(baseUrl: serverURL)
abstract class UtilRepository {
  factory UtilRepository(Dio dio) = _UtilRepository;

  @GET('/api/auth/util/techstack')
  Future<TechStackList> getTechStack({@Query('tech') required String tech});

  @GET('/api/auth/util/reissuetoken')
  @Headers({
    'refreshToken': 'true',
  })
  Future<AuthModel> getReIssueToken();
}
