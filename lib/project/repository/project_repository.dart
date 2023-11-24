import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/dio/dio_interceptor.dart';
import 'package:pllcare/project/param/param.dart';
import 'package:pllcare/dio/provider/dio_provider.dart';
import 'package:pllcare/project/param/project_create_param.dart';
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

  @POST('/api/auth/project')
  @Headers({
    'token': 'true',
  })
  Future<void> createProject({@Body() required CreateProjectFormParam param});

  @POST('/api/auth/project/{projectId}/complete')
  @Headers({
    'token': 'true',
  })
  Future<void> completeProject({@Path() required int projectId});

  @DELETE('/api/auth/project/{projectId}')
  @Headers({
    'token': 'true',
  })
  Future<void> deleteProject({@Path() required int projectId});

  @PUT('/api/auth/project/{projectId}')
  @Headers({
    'token': 'true',
  })
  Future<ProjectUpdateResponse> updateProject(
      {@Path() required int projectId,
      @Body() required UpdateProjectFormParam param});

  @GET('/api/auth/project/{projectId}')
  @Headers({
    'token': 'true',
  })
  Future<ProjectModel> getProject({@Path() required int projectId});
}
