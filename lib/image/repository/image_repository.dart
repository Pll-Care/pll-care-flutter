import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/dio/dio_interceptor.dart';
import 'package:pllcare/dio/provider/dio_provider.dart';
import 'package:retrofit/http.dart';

import '../model/image_model.dart';

part 'image_repository.g.dart';

final imageRepositoryProvider = Provider<ImageRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ImageRepository(dio);
});

@RestApi(baseUrl: serverURL)
abstract class ImageRepository {
  factory ImageRepository(Dio dio) = _ImageRepository;

  @MultiPart()
  @POST('/api/auth/upload/image')
  @Headers({
    'token': 'true',
  })
  Future<ImageModel> uploadImage({@Part(name: 'file') required File image, @Query('dir') required String dir});

  @DELETE('/api/auth/upload/image')
  @Headers({
    'token': 'true',
  })
  Future<void> deleteImage({@Query('url') required String url});
}
