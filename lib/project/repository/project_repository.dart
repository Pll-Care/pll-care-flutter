import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/dio/dio_interceptor.dart';
import 'package:pllcare/dio/param/param.dart';
import 'package:pllcare/dio/provider/dio_provider.dart';
import 'package:retrofit/http.dart';

import '../model/project_model.dart';

part 'project_repository.g.dart';

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ProjectRepository(dio, baseUrl: serverURL);
});

@RestApi()
abstract class ProjectRepository {
  factory ProjectRepository(Dio dio, {required String baseUrl}) =
      _ProjectRepository;

  @GET('/auth/main/uptodate')
  Future<List<ProjectUpToDate>> getUpToDate();

  @GET('/auth/main/closedeadline')
  Future<List<ProjectCloseDeadLine>> getCloseDeadLine();

  @GET('/auth/main/mostliked')
  Future<List<ProjectMostLiked>> getMostLiked();

  @GET('/auth/project/list')
  @Headers({
    'token': 'true',
  })

  Future<ProjectList> getProjectList(
      {@Queries() required ProjectParams params});
}
