import 'package:cloud_video_app/app/core/exceptions/network_exceptions.dart';
import 'package:cloud_video_app/app/core/values/endpoints.dart';
import 'package:cloud_video_app/app/data/models/user_info.dart';
import 'package:cloud_video_app/app/data/models/user_register.dart';
import 'package:cloud_video_app/app/data/providers/api_providers.dart';
import 'package:cloud_video_app/app/data/providers/auth_providers.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class AuthRepositories {
  //final dio = Dio();
  final _authProvider = Get.find<AuthProvider>();
  final _apiProvider = Get.find<ApiProvider>();

  Future<UserInfo> login(String phone, String password) async {
    try {
      logger.i(
        'Auth Repositories: login with phone => $phone and password => $password',
      );
      final response = await _apiProvider.postN(
        loginEndpoint,
        {'phone_number': phone, 'password': password},
        //options: Options(headers: {'Content-type': 'application/json'}),
      );
      if (response == null) {
        return response;
      }
      // logger.w('Login response: $response');
      // logger.w('Login response data: $response.data');

      // var userRegister = UserRegister();
      // userRegister = UserRegister.fromJson((response));
      var userInfo = UserInfo();
      userInfo = UserInfo.fromJson((response));

      if (userInfo.token == null) {
        throw Exception("Login failed: token is null in response");
      }
      _authProvider.isAuthenticated = true;
      _authProvider.authToken = userInfo.token!;
      // logger.i('authToken: ${_authProvider.authToken}');
      // logger.i("userInfo from Repositories: ${userInfo.toString()}");
      return userInfo;
    } on BadRequestException {
      rethrow;
    }
  }

  Future<UserRegister> signin(
    String name,
    String phone,
    String password,
  ) async {
    try {
      logger.i(
        'Auth Repositories: login with phone => $phone and password => $password',
      );
      final response = await _apiProvider.postN(
        registerEndPoint,
        {'name': name, 'phone_number': phone, 'password': password},
        //options: Options(headers: {'Content-type': 'application/json'}),
      );
      // logger.w('Login response: $response');
      // logger.w('Login response data: $response.data');

      // var userRegister = UserRegister();
      // userRegister = UserRegister.fromJson((response));
      var userRegister = UserRegister();
      userRegister = UserRegister.fromJson((response));

      if (userRegister.token == null) {
        throw Exception("Login failed: token is null in response");
      }
      _authProvider.isAuthenticated = true;
      _authProvider.authToken = userRegister.token!;
      // logger.i('authToken: ${_authProvider.authToken}');
      // logger.i("userRegister from Repositories: ${userRegister.toString()}");
      return userRegister;
    } on BadRequestException {
      rethrow;
    }
  }

  Future<dynamic> signout() async {
    try {
      logger.i('Auth Repositories: signing out ${_authProvider.authToken}');
      final response = await _apiProvider.post(
        signOutEndpoint,
        Options(
          headers: {'Authorization': 'Bearer ${_authProvider.authToken}'},
        ),
      );
      logger.i("Response from Auth Repositories: ${response}");
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

  Future createVente(Map<String, dynamic> json) async {
    try {
      logger.i("Json from Repositories: ${json}");
      final res = await _apiProvider.post(createVenteEndpoint, json);
      logger.w('AuthRepositories: Create Vente response: $res');
      return res;
    } on BadRequestException {
      rethrow;
    }
  }

  // Future<List<dynamic>> fetchVentes() async {
  //   try {
  //     logger.i("Auth Repositories: Fetching list of ventes");
  //     final res = await _apiProvider.get(venteListEndpoint);
  //     logger.w('List Ventes response: $res');
  //     return res;
  //   } on BadRequestException {
  //     rethrow;
  //   }
  // }

  // Future<List<dynamic>> fetchVentes() async {
  //   final response = await _authProvider.getVentes(); // Calls provider
  //   if (response.statusCode == 200) {
  //     // Assuming response.body is a JSON array
  //     return response.body;
  //   } else {
  //     throw Exception('Failed to fetch ventes');
  //   }
  // }

  // Future<VenteInfo> listVentes() async {
  //   final response = await _apiProvider.getVentes();
  //   //final ventesResponse = VenteResponse.fromJson(response.data);
  //   return VenteInfo.fromJson(response.data);
  // }
}
