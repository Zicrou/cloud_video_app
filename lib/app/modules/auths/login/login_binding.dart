import 'package:cloud_video_app/app/data/providers/auth_providers.dart';
import 'package:cloud_video_app/app/data/repositories/auth_repositories.dart';
import 'package:cloud_video_app/app/modules/auths/auth_controller.dart';
import 'package:cloud_video_app/app/modules/auths/login/login_controller.dart';
import 'package:get/get.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthProvider());
    Get.put(LoginController());
    Get.put(AuthRepositories());
    Get.put(AuthController());
  }
}
