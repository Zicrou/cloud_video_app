import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_video_app/app/core/exceptions/network_exceptions.dart';
import 'package:cloud_video_app/app/core/interceptors/api_interceptors.dart';
import 'package:cloud_video_app/app/utils/no_internet_snack.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, Response;
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class ApiProvider {
  final Dio _dio = Dio();
  final Dio dio = Dio();

  ApiProvider() {
    _dio.interceptors.add(ApiInterceptor());
  }

  static Duration timeOutDuration = 20.seconds;

  Future<dynamic> requestWrapper(Function() doRequest) async {
    try {
      var response = await doRequest();
      return _processResponse(response);
    } on SocketException {
      noInternetSnack();
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time');
    } on DioException catch (e, s) {
      logger.e(e, stackTrace: s);

      if (e.response != null) {
        throw _processResponse(e.response);
      }

      //errorMessage(e.response!.data['message'].toString());
      rethrow;
    }
  }

  Future<dynamic> getN(String api, {Map<String, dynamic>? params}) async {
    return requestWrapper(
      () async => await dio.get(api, queryParameters: params),
    );
  }

  Future<dynamic> get(String api, {Map<String, dynamic>? params}) async {
    return requestWrapper(
      () async => await _dio.get(api, queryParameters: params),
    );
  }

  Future<dynamic> options(String api, {Map<String, dynamic>? params}) async {
    return requestWrapper(
      () async => await _dio.request(
        api,
        queryParameters: params,
        options: Options(method: 'OPTIONS'),
      ),
    );
  }

  Future<dynamic> post(String api, dynamic payload) async {
    logger.i("Url : ${api}");
    return requestWrapper(() async => await _dio.post(api, data: payload));
  }

  Future<dynamic> postN(String api, dynamic payload) async {
    return requestWrapper(() async => await dio.post(api, data: payload));
  }

  Future<dynamic> postFormData(
    String api,
    Map<String, dynamic> payloadObj,
  ) async {
    var formData = FormData.fromMap(payloadObj);
    return requestWrapper(
      () async => await _dio
          .post(
            api,
            data: formData,
            options: Options(
              followRedirects: false,
              validateStatus: (status) => true,
              contentType: "multipart/form-data",
            ),
          )
          .timeout(timeOutDuration),
    );
  }

  Future<dynamic> putFormData(
    String api,
    Map<String, dynamic> payloadObj,
  ) async {
    var formData = FormData.fromMap(payloadObj);
    return requestWrapper(
      () async => await _dio
          .put(
            api,
            data: formData,
            options: Options(
              followRedirects: false,
              validateStatus: (status) => true,
              contentType: "multipart/form-data",
            ),
          )
          .timeout(timeOutDuration),
    );
  }

  Future<dynamic> patch(String api, dynamic payloadObj) async {
    var payload = json.encode(payloadObj);
    return requestWrapper(
      () async => await _dio
          .patch(
            api,
            data: payload,
            options: Options(
              followRedirects: false,
              validateStatus: (status) => true,
            ),
          )
          .timeout(timeOutDuration),
    );
  }

  Future<dynamic> put(String api, dynamic payloadObj) async {
    return requestWrapper(
      () async => await _dio
          .put(
            api,
            data: payloadObj,
            options: Options(
              followRedirects: false,
              validateStatus: (status) => true,
            ),
          )
          .timeout(timeOutDuration),
    );
  }

  Future<dynamic> delete(String api) async {
    return requestWrapper(
      () async => await _dio.delete(api).timeout(timeOutDuration),
    );
  }

  Future<dynamic> head(String api, dynamic payloadObj) async {
    return requestWrapper(
      () async =>
          await _dio.head(api, data: payloadObj).timeout(timeOutDuration),
    );
  }

  dynamic _processResponse(response) {
    if (response?.statusCode != null) {
      switch (response.statusCode) {
        case 200:
        case 201:
        case 203:
        case 204:
        case 206:
          logger.i(response.data.toString());

          return response.data;
        case 400:
          throw BadRequestException(response.toString());
        case 401:
          throw BadCredentialException(response.toString());
        case 403:
          throw UnAuthorizedException(response.toString());
        case 500:
        default:
          throw FetchDataException(
            'Error occurred with code : ${response.statusCode}',
            response.toString(),
          );
      }
    } else {
      logger.d('NO STATUS CODE');
      throw FetchDataException('Error occurred with no code $response');
    }
  }
}
