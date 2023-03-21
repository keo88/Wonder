import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:wonder_flutter/app/common/constants.dart';
import 'package:wonder_flutter/app/data/http_provider.dart';
import 'package:wonder_flutter/app/data/models/base_model/http_response_model.dart';

import 'errors/api_error.dart';

class HttpProviderDioImpl extends getx.GetLifeCycle with HttpProvider {
  late final Dio dio; // With default `Options`.

  @override
  void onInit() {
    super.onInit();
    _configureDio();
  }

  void _configureDio() {
    final options = BaseOptions(
      baseUrl: Constants.baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    );
    dio = Dio(options);
  }

  @override
  Future<HttpResponse> httpGet(String path, Map<String, dynamic> queryParameters) async {

    try {
      var res = await dio.get(path, queryParameters: queryParameters);
      return res.data as HttpResponse;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        return e.response!.data;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        throw ApiError(
          type: ErrorType.noConnection,
          error: e.message,
        );
      }
    }
  }

  @override
  Future<HttpResponse> httpPost(String path, Map<String, dynamic> body) async {
    try {
      var res = await dio.post(path, data: body);
      return HttpResponse.fromJson(res.data);
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        return HttpResponse.fromJson(e.response!.data);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        throw ApiError(
          type: ErrorType.noConnection,
          error: e.message,
        );
      }
    }
  }

  @override
  void setToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  @override
  void setHeader(String key, String value) {
    dio.options.headers[key] = value;
  }

  @override
  void removeHeader(String key) {
    dio.options.headers.remove(key);
  }
}