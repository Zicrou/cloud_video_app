import 'dart:convert';

import 'package:cloud_video_app/app/core/values/endpoints.dart';
import 'package:cloud_video_app/app/data/models/user_info.dart';
import 'package:cloud_video_app/app/data/models/user_register.dart';
import 'package:cloud_video_app/app/data/providers/auth_providers.dart';
import 'package:cloud_video_app/app/data/repositories/auth_repositories.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final logger = Logger();

class AuthServices extends GetxService {

  final _authRepositories = Get.find<AuthRepositories>();

  @override
  void onInit() {
  
    _authRepositories;

    super.onInit();

  }

  Future<UserRegister> register({
    required String name,
    required String email,
    required String password,
  }) async {

    print("Data: $name, $email, $password");

    return await _authRepositories.signin( name, email, password,);
  }

  Future<UserInfo> login({
    required String email,
    required String password,
  }) async {
    return await _authRepositories.login(email, password);
  }

  Future<dynamic> signout() async {
    logger.i('AuthService: Signing out');
    return await _authRepositories.signout();
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    
    final response = await _authRepositories.getCurrentUser();

    return response as Map<String, dynamic>;

  }
}
