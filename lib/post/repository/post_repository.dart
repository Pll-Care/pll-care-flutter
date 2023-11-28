import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/dio/dio_interceptor.dart';
import 'package:pllcare/dio/provider/dio_provider.dart';
import 'package:pllcare/post/param/post_param.dart';
import 'package:retrofit/http.dart';

import '../../common/page/param/page_param.dart';
import '../model/post_model.dart';

part 'post_repository.g.dart';

final postRepositoryProvider = Provider<PostRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return PostRepository(dio);
});

@RestApi(baseUrl: serverURL)
abstract class PostRepository {
  factory PostRepository(Dio dio) = _PostRepository;

  @GET('/api/auth/post/{postId}')
  // @Headers({
  //   'token': 'true',
  // })
  Future<PostModel> getPost({@Path() required int postId});

  @PUT('/api/auth/post/{postId}')
  @Headers({
    'token': 'true',
  })
  Future<void> updatePost(
      {@Path() required int postId, @Body() required UpdatePostParam param});

  @DELETE('/api/auth/post/{postId}')
  @Headers({
    'token': 'true',
  })
  Future<void> deletePost({@Path() required int postId});

  @POST('/api/auth/post/{postId}')
  @Headers({
    'token': 'true',
  })
  Future<void> createPost(
      {@Path() required int postId, @Body() required CreatePostParam param});

  @POST('/api/auth/post/{postId}/like')
  @Headers({
    'token': 'true',
  })
  Future<void> likePost({@Path() required int postId});

  @POST('/api/auth/post/{postId}/applycancel')
  @Headers({
    'token': 'true',
  })
  Future<void> applyCancelPost({@Path() required int postId});

  @POST('/api/auth/post/{postId}/apply')
  @Headers({
    'token': 'true',
  })
  Future<void> applyPost(
      {@Path() required int postId, @Body() required ApplyPostParam param});

  @GET('/api/auth/post/list')
  // @Headers({
  //   'token': 'true',
  // })
  Future<PostList> getPostList(
      { @Body() required PageParams param});
}
