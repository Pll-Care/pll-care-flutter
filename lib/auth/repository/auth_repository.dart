import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/auth/param/auth_param.dart';
import 'package:pllcare/dio/dio_interceptor.dart';
import 'package:pllcare/dio/provider/dio_provider.dart';
import 'package:retrofit/http.dart';

import '../model/auth_model.dart';

part 'auth_repository.g.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref){
  final dio = ref.watch(dioProvider);
  final repository = AuthRepository(dio, baseUrl: serverURL);
  return repository;
});

@RestApi()
abstract class AuthRepository {
  factory AuthRepository(Dio dio, {String baseUrl}) = _AuthRepository;

  @POST('/api/auth/flutter/signup')
  Future<AuthModel> signUp({@Body() required AuthParameter param});
}
