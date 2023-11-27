import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pllcare/common/page/param/page_param.dart';
import 'package:pllcare/dio/dio_interceptor.dart';
import 'package:pllcare/dio/provider/dio_provider.dart';
import 'package:pllcare/management/model/leader_model.dart';
import 'package:pllcare/schedule/model/schedule_calendar_model.dart';
import 'package:pllcare/schedule/param/schedule_param.dart';
import 'package:retrofit/http.dart';

import '../model/apply_model.dart';
import '../model/team_member_model.dart';
import '../param/management_param.dart';

part 'management_repository.g.dart';

final managementRepositoryProvider = Provider<ManagementRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ManagementRepository(dio);
});

@RestApi(baseUrl: serverURL)
abstract class ManagementRepository {
  factory ManagementRepository(Dio dio) = _ManagementRepository;

  @GET('/api/auth/project/{projectId}/memberlist')
  @Headers({
    'token': 'true',
  })
  Future<List<TeamMemberModel>> getMemberList({@Path() required int projectId});

  @GET('/api/auth/project/{projectId}/applylist')
  @Headers({
    'token': 'true',
  })
  Future<List<ApplyModel>> getApplyList({@Path() required int projectId});

  @POST('/api/auth/project/{projectId}/applyaccept')
  @Headers({
    'token': 'true',
  })
  Future<void> applyAccept(
      {@Path() required int projectId, @Body() required ApplyParam param});

  @POST('/api/auth/project/{projectId}/applyreject')
  @Headers({
    'token': 'true',
  })
  Future<void> applyReject(
      {@Path() required int projectId, @Body() required ApplyParam param});

  @DELETE('/api/auth/project/{projectId}/kickout')
  @Headers({
    'token': 'true',
  })
  Future<void> kickOut(
      {@Path() required int projectId, @Body() required KickOutParam param});

  @PUT('/api/auth/project/{projectId}/leaderchange')
  @Headers({
    'token': 'true',
  })
  Future<void> changeLeader(
      {@Path() required int projectId, @Body() required ChangeLeaderParam param});

  @PUT('/api/auth/project/{projectId}/positionchange')
  @Headers({
    'token': 'true',
  })
  Future<void> changePosition(
      {@Path() required int projectId, @Body() required ChangePositionParam param});

  @GET('/api/auth/project/{projectId}/isleader')
  @Headers({
    'token': 'true',
  })
  Future<LeaderModel> getIsLeader(
      {@Path() required int projectId});
}
