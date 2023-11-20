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

  @GET('/api/auth/main/uptodate')
  Future<List<ProjectUpToDate>> getUpToDate();

  @GET('/api/auth/main/closedeadline')
  Future<List<ProjectCloseDeadLine>> getCloseDeadLine();

  @GET('/api/auth/main/mostliked')
  Future<List<ProjectMostLiked>> getMostLiked();

  @GET('/api/auth/project/list')
  @Headers({
    'token': 'true',
  })
  Future<ProjectList> getProjectList(
      {@Queries() required ProjectParams params});

  @DELETE('/api/auth/project/{projectId}/selfout')
  @Headers({
    'token': 'true',
  })
  Future<void> selfOutProject({@Path() required int projectId});
}
