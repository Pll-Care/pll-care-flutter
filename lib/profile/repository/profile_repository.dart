import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/common/page/param/page_param.dart';
import 'package:pllcare/dio/dio_interceptor.dart';
import 'package:pllcare/dio/provider/dio_provider.dart';
import 'package:retrofit/http.dart';

import '../model/profile_apply_model.dart';
import '../model/profile_eval_chart_model.dart';
import '../model/profile_eval_model.dart';
import '../model/profile_model.dart';
import '../model/profile_post_model.dart';
import '../model/project_experience_model.dart';
import '../param/profile_param.dart';

part 'profile_repository.g.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return UserRepository(dio);
});

@RestApi(baseUrl: serverURL)
abstract class UserRepository {
  factory UserRepository(Dio dio) = _UserRepository;

  @PUT('/api/auth/profile/{memberId}')
  @Headers({
    'token': 'true',
  })
  Future<void> updateIntro(
      {@Path() required int memberId, @Body() required UpdateIntroParam param});

  @PATCH('/api/auth/profile/{memberId}')
  @Headers({
    'token': 'true',
  })
  Future<void> patchProfile(
      {@Path() required int memberId,
      @Body() required PatchProfileParam param});

  @GET('/api/auth/profile/{memberId}/validate')
  @Headers({
    'token': 'true',
  })
  Future<ProfileValidateModel> validateProfile({
    @Path() required int memberId,
  });

  @GET('/api/auth/profile/{memberId}/roletechstack')
  // @Headers({
  //   'token': 'true',
  // })
  Future<RoleTechStackModel> getRoleTechStack({
    @Path() required int memberId,
  });

  @GET('/api/auth/profile/{memberId}/post')
  @Headers({
    'token': 'true',
  })
  Future<ProfilePostList> getPost({
    @Path() required int memberId,
    @Query('state') required StateType state,
    @Queries() required PageParams param,
  });

  @GET('/api/auth/profile/{memberId}/post/like')
  @Headers({
    'token': 'true',
  })
  Future<ProfilePostList> getPostLike({
    @Path() required int memberId,
    @Queries() required PageParams param,
  });

  @GET('/api/auth/profile/{memberId}/experience')
  // @Headers({
  //   'token': 'true',
  // })
  Future<ProjectExperienceList> getProjectExperience({
    @Path() required int memberId,
  });

  @GET('/api/auth/profile/{memberId}/evaluation')
  // @Headers({
  //   'token': 'true',
  // })
  Future<ProjectExperienceList> getProfileEvalList({
    @Path() required int memberId,
    @Queries() required PageParams param,
  });

  @GET('/api/auth/profile/{memberId}/evaluation/{projectId}')
  // @Headers({
  //   'token': 'true',
  // })
  Future<ProfileEvalModel> getProfileEval({
    @Path() required int memberId,
    @Path() required int projectId,
  });

  @GET('/api/auth/profile/{memberId}/evaluation/chart')
  // @Headers({
  //   'token': 'true',
  // })
  Future<ProfileEvalChartModel> getProfileEvalChart({
    @Path() required int memberId,
  });

  @GET('/api/auth/profile/{memberId}/evaluation/contact')
  // @Headers({
  //   'token': 'true',
  // })
  Future<ContactModel> getProfileContact({
    @Path() required int memberId,
  });

  @GET('/api/auth/profile/{memberId}/bio')
  // @Headers({
  //   'token': 'true',
  // })
  Future<ProfileIntroModel> getProfileIntro({
    @Path() required int memberId,
  });

  @GET('/api/auth/profile/{memberId}/apply')
  @Headers({
    'token': 'true',
  })
  Future<ProfileApplyList> getProfileApplyList({
    @Path() required int memberId,
    @Queries() required PageParams param,
  });
}
