import 'dart:convert';

import 'package:cloud_video_app/app/data/providers/auth_providers.dart';
import 'package:cloud_video_app/app/data/repositories/auth_repositories.dart';
import 'package:cloud_video_app/app/data/services/auth_services.dart';
import 'package:cloud_video_app/app/modules/login/login_screen.dart';
import 'package:cloud_video_app/app/modules/videos/videos/video_list_screen.dart';
import 'package:cloud_video_app/app/utils/messages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final AuthProvider authProvider = Get.find<AuthProvider>();
  final AuthServices authServices = AuthServices();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  

  get isLoading => _isLoading.value;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneNumberController = TextEditingController();

  var isEmailValid = true.obs;
  var isPasswordValid = true.obs;
  var isNameValid = true.obs;
  var isPhoneNumberValid = true.obs;


  void login() async {
    print("LoginFormKey: $loginFormKey");
    try {
      print("conecting..");
      _isLoading.value = true;
      if (loginFormKey.currentState!.validate()) {
        loginFormKey.currentState!.save();
        String email = emailController.text.trim();
        String password = passwordController.text.trim();

        // Call the post Api method to send data
        var userInfo = await authServices.login(email: email, password: password);
        print("Response Auth Controller: ${userInfo}");

        emailController.clear();
        
        passwordController.clear();

        Get.offAll(VideoListScreen());

        goodMessage("Connexion avec succés");

      }
    } catch (e) {
     
      errorMessage("Impossible de se connecter");
     
      print("Error: ${e}");
   
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
        print("Signin in signinFormKey : ${signupFormKey}");
        _isLoading.value = true;
        var userRegistred =  authServices.register(name: name, email: email, password: password);
        
        print("Response userRegistered: $userRegistred");
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
