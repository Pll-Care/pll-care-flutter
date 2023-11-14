import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pllcare/common/provider/secure_storage_provider.dart';
import 'package:pllcare/dio/dio_interceptor.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final storage = ref.watch(secureStorageProvider);
  dio.interceptors.add(CustomDioInterceptor(storage: storage, ref: ref));
  return dio;
});