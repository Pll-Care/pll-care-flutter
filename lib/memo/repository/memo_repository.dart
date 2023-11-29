import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/common/page/param/page_param.dart';
import 'package:pllcare/dio/dio_interceptor.dart';
import 'package:pllcare/dio/provider/dio_provider.dart';
import 'package:pllcare/memo/param/memo_param.dart';
import 'package:retrofit/http.dart';

import '../model/memo_model.dart';

part 'memo_repository.g.dart';

final memoRepositoryProvider = Provider<MemoRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return MemoRepository(dio);
});

@RestApi(baseUrl: serverURL)
abstract class MemoRepository {
  factory MemoRepository(Dio dio) = _MemoRepository;

  @GET('api/auth/memo/{memoId}')
  @Headers({
    'token': 'true',
  })
  Future<MemoModel> getMemo(
      {@Path() required int memoId,
      @Query('project_id') required int projectId});

  @PUT('api/auth/memo/{memoId}')
  @Headers({
    'token': 'true',
  })
  Future<void> updateMemo({
    @Path() required int memoId,
    @Body() required MemoParam param,
  });

  @DELETE('api/auth/memo/{memoId}')
  @Headers({
    'token': 'true',
  })
  Future<void> deleteMemo({
    @Path() required int memoId,
    @Body() required DeleteMemoParam param,
  });

  @POST('api/auth/memo')
  @Headers({
    'token': 'true',
  })
  Future<void> createMemo({
    @Body() required MemoParam param,
  });

  @POST('api/auth/memo/{memoId}/bookmark')
  @Headers({
    'token': 'true',
  })
  Future<void> bookmarkMemo({
    @Path() required int memoId,
    @Body() required BookmarkMemoParam param,
  });

  @GET('api/auth/memo/list')
  @Headers({
    'token': 'true',
  })
  Future<MemoList> getMemoList({
    @Query('project_id') required int projectId,
    @Queries() required PageParams param,
  });

  @GET('api/auth/memo/bookmarklist')
  @Headers({
    'token': 'true',
  })
  Future<MemoList> getBookmarkMemoList({
    @Query('project_id') required int projectId,
    @Queries() required PageParams param,
  });
}
