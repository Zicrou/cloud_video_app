import 'package:get/get.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class LoginController extends GetxController {  

  void login() async {
    try {} catch (e) {
      throw ("Impossible de se connecter $e");
    }
  }
}
