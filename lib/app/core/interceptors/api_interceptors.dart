import 'package:cloud_video_app/app/data/providers/auth_providers.dart';
import 'package:cloud_video_app/app/utils/messages.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as g;
import 'package:logger/logger.dart';

final logger = Logger();

class ApiInterceptor extends Interceptor {
  final _authProvider = g.Get.find<AuthProvider>();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_authProvider.isAuthenticated) {
      options.headers['Authorization'] = "Bearer ${_authProvider.authToken}";
      logger.i("Bearer ${_authProvider.authToken}");
      logger.i(options.data);
    }
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;
    if(response != null){
    
      logger.e(
        'RESPONSE | path: ${response.requestOptions.path} '
        
        'method: ${response.requestOptions.method} '
        
        'statusCode: ${response.statusCode} '
        
        'statusMessage: ${response.statusMessage} '
        
        'body: $response',
        
      );
    errorMessage(response.data['error']);
    handler.next(err);
    }else{
      logger.e(
        'RESPONSE | path: ${response?.requestOptions.path} '
        'body: $response',
        
      );
      errorMessage(response?.data['error']);
      handler.next(err);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.i(
      'RESPONSE | path: ${response.requestOptions.path} method: ${response.requestOptions.method} statusCode: ${response.statusCode} statusMessage: ${response.statusMessage} body: $response',
    );
    handler.next(response);
  }
}
