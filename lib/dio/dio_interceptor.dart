import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../common/logger/custom_logger.dart';

const String serverURL = "http://59.6.173.110:8080/api";

class CustomDioInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  final Ref ref;

  CustomDioInterceptor({
    required this.storage,
    required this.ref,
  });

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // logger.d("Logger is working!");

    // 요청 전 accestoken을 header에 주입
    if (options.headers['token'] == 'true') {
      String? accessToken = await storage.read(key: 'accessToken');
      options.headers.remove('token');
      options.headers.addAll({'Authorization': 'Bearer $accessToken'});
    }
    if (options.headers['refreshToken'] == 'true') {
      String? refreshToken = await storage.read(key: 'refreshToken');
      options.headers.remove('refreshToken');
      options.headers.addAll({'Authorization': 'Bearer $refreshToken'});
    }
    List<String> requestLog = [];
    requestLog.add(
        '[REQUEST] [${options.method}] ${options.baseUrl}${options.uri.path}\n');

    if (options.uri.queryParameters.isNotEmpty) {
      requestLog.add('[QueryParameters] ${options.uri.queryParameters}\n');
    }
    if (options.uri.data != null) {
      requestLog.add('[URI Parameters] ${options.uri.data!.parameters}\n');
    }
    requestLog.add('[Headers] ${options.headers}\n');
    requestLog.add('[Data] ${options.data}');

    logger.d(requestLog.reduce((value, element) => value + element));
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    List<String> errorLog = [];

    errorLog.add('[ERROR] [${err.response?.statusCode ?? 'None StatusCode'}] [${err.requestOptions.method}] ${err.requestOptions.baseUrl}${err.requestOptions.uri.path}\n');
    if (err.requestOptions.queryParameters.isNotEmpty) {
      errorLog.add('[QueryParameters] ${err.requestOptions.queryParameters}\n');
    }
    errorLog.add('[Headers] ${err.requestOptions.headers}');
    logger.w(errorLog.reduce((value, element) => value + element));

    // 어세스 토큰이 만료되 경우
    if (err.response!.statusCode == 401 &&
        err.requestOptions.uri.path != '/dmt-auth/oauth2/token') {
      try {
        Dio dio = Dio();
        // Map<String, String> queryParameter = await loadTokenCredential(storage);
        // dio.options.queryParameters.addAll(queryParameter);

        dio.options.headers['Content-Type'] =
        'application/x-www-form-urlencoded';
        var response = await dio.post('$serverURL/dmt-auth/oauth2/token');
        String newAccessToken = response.data["accessToken"]["tokenValue"];
        await storage.write(key: "token", value: newAccessToken);

        err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
        log("[RE-REQUEST] [${err.requestOptions.method}] ${err.requestOptions.baseUrl}${err.requestOptions.path}");
        if (err.requestOptions.uri.queryParameters.isNotEmpty) {
          log("[RE-REQUEST] [${err.requestOptions.method}] ${err.requestOptions.uri.queryParameters}");
        }
        // 재요청
        final reResponse = await dio.fetch(err.requestOptions);
        return handler.resolve(reResponse);
      } on DioException catch (e) {
        // 리프레쉬 토큰 만료 된 경우
        log("리프레쉬 만료 언어선택으로 이동 !!");
        // await ref.read(authProvider.notifier).logout();
        return;
        // handler.reject(e);
      }
    }
    switch (err.response?.statusCode) {
      case 400:
        if (err.response!.data['_metadata']['exception'] ==
            'java.rmi.NoSuchObjectException') {
          // showToast(
          //     context: null, message: tr("data_null"), type: ToastType.ERROR);
          log("400 Error = ${err.response!}");
          return handler.resolve(err.response!);
        }
    // case 401:
    // case 404:
    // case 409:
    // case 500:
    }
    log("err.type = ${err.type}");
    if (err.type == DioExceptionType.badResponse) {
      print(
          "err.response!.data['_metadata'] ${err.response!.data['_metadata']}");
      return handler.resolve(err.response!);

    }

    handler.reject(err);
    return handler.resolve(err.response!);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    List<String> responseLog = [];
    responseLog.add('[RESPONSE] [${response.requestOptions.method}] ${response.requestOptions.baseUrl}${response.requestOptions.path}\n');
    if (response.requestOptions.uri.queryParameters.isNotEmpty) {
      responseLog.add('[QueryParameters] ${response.requestOptions.uri.queryParameters}');
    }
    logger.d(responseLog.reduce((value, element) => value + element));


    super.onResponse(response, handler);
  }
}
