import 'package:cloud_video_app/app/core/exceptions/network_exceptions.dart';
import 'package:cloud_video_app/app/core/values/endpoints.dart';
import 'package:cloud_video_app/app/data/models/user.dart';
import 'package:cloud_video_app/app/data/models/user_info.dart';
import 'package:cloud_video_app/app/data/models/user_register.dart';
import 'package:cloud_video_app/app/data/providers/api_providers.dart';
import 'package:cloud_video_app/app/data/providers/auth_providers.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';

final logger = Logger();
class AuthRepositories {
  //final dio = Dio();
  final _authProvider = Get.find<AuthProvider>();
  final _apiProvider = Get.find<ApiProvider>();

  Future<UserInfo> login(String email, String password) async {
    try {
      print(
        'Auth Repositories: login with email => $email and password => $password',
      );
      final response = await _apiProvider.postN(
        loginEndpoint,
        {'email': email, 'password': password},
        //options: Options(headers: {'Content-type': 'application/json'}),
      );
      if (response == null) {
        return response;
      }

      var userInfo = UserInfo();

      userInfo = UserInfo.fromJson((response));

      if (userInfo.token == null) {
        throw Exception("Login failed: token is null in response");
      }
      _authProvider.isAuthenticated = true;
      _authProvider.authToken = userInfo.token!;
      print('authToken: ${_authProvider.authToken}');
      print("userInfo from Repositories: ${userInfo.toString()}");
      return userInfo;
    } on BadRequestException {
      rethrow;
    }
  }

  Future<UserRegister> signin(
    String name,
    String email,
    String password,
  ) async {
    try {
      print(
        'Auth Repositories: login with email => $email and password => $password',
      );
      final response = await _apiProvider.postN(
        registerEndPoint,
        {'name': name, 'email': email, 'password': password},
      );

      var userRegister = UserRegister();
      userRegister = UserRegister.fromJson((response));

      if (userRegister.token == null) {
        throw Exception("Login failed: token is null in response");
      }
      _authProvider.isAuthenticated = true;
      _authProvider.authToken = userRegister.token!;
      // print('authToken: ${_authProvider.authToken}');
      // print("userRegister from Repositories: ${userRegister.toString()}");
      return userRegister;
    } on BadRequestException {
      rethrow;
    }
  }

  Future<dynamic> signout() async {
    try {
      print('Auth Repositories: signing out ${_authProvider.authToken}');
      final response = await _apiProvider.post(
        signOutEndpoint,
        Options(
          headers: {'Authorization': 'Bearer ${_authProvider.authToken}'},
        ),
      );
      print("Response from Auth Repositories: ${response}");
      _authProvider.reset();
      if (!_authProvider.isAuthenticated) {
        return true;
      } else {
        return false;
      }
    } on BadRequestException {
      rethrow;
    }
  }

  Future<User> getCurrentUser() async {
    final path = '$baseUrl/user';
    print("Path to get getCurrentUser: $path");
    final response = await _apiProvider.get(path);

    print('CURRENT USER RESPONSE: $response');
    
    print('CURRENT USER TYPE: ${response.runtimeType}');


    return User.fromJson(response as Map<String, dynamic>);
  }

  Future<void> testCurrentUser() async {
    try {
      final user = await getCurrentUser();

      logger.i('CURRENT USER: $user');
    } catch (e) {
      logger.e('CURRENT USER ERROR: $e');
    }
  }
}
