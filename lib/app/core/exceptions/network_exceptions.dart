import 'dart:convert';

import 'package:cloud_video_app/app/core/exceptions/app_exceptions.dart';


class BadRequestException extends AppException {
  BadRequestException([String? message, String? url])
    : super(message, 'Bad Request', url);

  get errorList => jsonDecode(message!)['message'];

  @override
  String toString() {
    return 'BadRequestException: $message';
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message, String? url])
    : super(message, 'Unable to process', url);
}

class ApiNotRespondingException extends AppException {
  ApiNotRespondingException([String? message, String? url])
    : super(message, 'Api not responded in time', url);
}

class UnAuthorizedException extends AppException {
  UnAuthorizedException([String? message, String? url])
    : super(message, 'UnAuthorized request', url);
}

class BadCredentialException extends AppException {
  BadCredentialException([String? message, String? url])
    : super(message, 'Bad credential request', url);
}
