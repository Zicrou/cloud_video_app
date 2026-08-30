import 'package:cloud_video_app/app/modules/auths/auth_controller.dart';
import 'package:cloud_video_app/app/modules/auths/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: controller.signupFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 173, 253),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Obx(
                  () => TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Svp veuillez remplir le champs";
                      }
                      return null;
                    },
                    controller: controller.nameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: Color.fromARGB(255, 0, 173, 253),
                      ),
                      labelText: "Nom & Prénom",
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 0, 173, 253),
                      ),
                      errorText: controller.isNameValid.value
                          ? null
                          : "Nom et Prénom invalide",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    obscureText: false,
                  ),
                ),
                SizedBox(height: 20),
                Obx(
                  () => TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Svp veuillez remplir le champs";
                      }
                      return null;
                    },
                    controller: controller.emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: Color.fromARGB(255, 0, 173, 253),
                      ),
                      labelText: "Email",
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 0, 173, 253),
                      ),
                      errorText: controller.isEmailValid.value
                          ? null
                          : "Numéro de téléphone invalide",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                SizedBox(height: 20),
                Obx(
                  () => TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Svp veuillez remplir le champs";
                      }
                      return null;
                    },
                    controller: controller.passwordController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Color.fromARGB(255, 0, 173, 253),
                      ),
                      labelText: "Mot de passe",
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 0, 173, 253),
                      ),
                      errorText: controller.isPasswordValid.value
                          ? null
                          : "Mot de passe invalide, saisir au moins 6 caractéres",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 20),

                SizedBox(height: 20),
                Obx(
                  () => controller.isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Color.fromARGB(255, 0, 173, 253),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () => controller.signup(),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 0, 173, 253),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                ),
                TextButton(
                  onPressed: () => Get.to(LoginScreen()),
                  child: Text(
                    "Already have an account ? Sign In",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 173, 253),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
