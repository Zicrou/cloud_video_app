import 'package:cloud_video_app/app/data/models/user_info.dart';
import 'package:cloud_video_app/app/data/models/user_register.dart';
import 'package:cloud_video_app/app/data/repositories/auth_repositories.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class AuthServices extends GetxService {
  //final _authProvider = Get.find<AuthProvider>();
  final _authRepositories = Get.find<AuthRepositories>();

  @override
  void onInit() {
    // logger.w(
    //   "Is AuthRepositories registered? ${Get.isRegistered<AuthRepositories>()}",
    // );
    _authRepositories;
    super.onInit();
  }

  // Future<VenteInfo> getAllVentes() async {
  //   try {
  //     // final response = await _dio.get('http://10.0.2.2:8000/api/V1/ventes');
  //     return await _authRepositories.listVentes();
  //   } catch (e) {
  //     throw Exception("Error fetching ventes: $e");
  //   }
  // }

  Future<UserInfo> login(String phone, String password) async {
    logger.w("AuthReppositories: ${_authRepositories}");

    logger.i(
      'AuthService: Logging in with phone: $phone and password: $password',
    );
    return await _authRepositories.login(phone, password);
  }

  Future<UserRegister> signin(
    String name,
    String phone,
    String password,
  ) async {
    logger.w("AuthReppositories: ${_authRepositories}");

    logger.i(
      'AuthService: Signing in with name: ${name}, phone: $phone and password: $password',
    );
    return await _authRepositories.signin(name, phone, password);
  }

  Future<dynamic> signout() async {
    logger.i('AuthService: Signing out');
    return await _authRepositories.signout();
  }

  // createVente(Map<String, dynamic> json) async {
  //   return await _authRepositories.createVente();
  // }

  // ListVentes() async {
  //   logger.i('AuthService: Fetching list of ventes');
  //   return await _authRepository.listVentes();
  // }
}
