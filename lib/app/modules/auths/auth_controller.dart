import 'package:cloud_video_app/app/data/providers/auth_providers.dart';
import 'package:cloud_video_app/app/data/services/auth_services.dart';
import 'package:cloud_video_app/app/modules/auths/login/login_screen.dart';
import 'package:cloud_video_app/app/modules/videos/videos/video_list_screen.dart';
import 'package:cloud_video_app/app/utils/messages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthProvider authProvider = Get.find<AuthProvider>();
  final AuthServices authServices = AuthServices();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  

  dynamic get isLoading => _isLoading.value;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneNumberController = TextEditingController();

  var isEmailValid = true.obs;
  var isPasswordValid = true.obs;
  var isNameValid = true.obs;
  var isPhoneNumberValid = true.obs;


  void login() async {

    try {

      _isLoading.value = true;

      if (loginFormKey.currentState!.validate()) {

        loginFormKey.currentState!.save();

        String email = emailController.text.trim();

        String password = passwordController.text.trim();

        // Call the post Api method to send data
        await authServices.login(email: email, password: password);

        emailController.clear();
        
        passwordController.clear();

        Get.offAll(VideoListScreen());

        goodMessage("Connexion avec succés");

      }
    } catch (e) {
     
      errorMessage("Impossible de se connecter");
     
    } finally {
   
      _isLoading.value = false;
   
    }
 
  }

  void signup() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String name = nameController.text.trim();
    try {
      if (signupFormKey.currentState!.validate()) {
        //signupFormKey.currentState!.save();
        _isLoading.value = true;
        await authServices.register(name: name, email: email, password: password);
        
        // authProvider.userRegister =  await userRegistred;
        Get.offAll(() => LoginScreen());

        goodMessage("Succés: Inscription");
      }
    } catch (e) {
      errorMessage("Erreur");
    } finally {
      _isLoading.value = false;
    }
    //validating email and password and checking a static email just for checking

    //var response = remoteServices.signUp(name, phoneNumber, password);
  }

  Future<void> logout() async {
    Get.offAll(() => LoginScreen());
    authProvider.reset();
    goodMessage("Déconneté");
  }
}
