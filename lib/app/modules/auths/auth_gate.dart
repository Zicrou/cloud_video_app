import 'package:cloud_video_app/app/data/providers/auth_providers.dart';
import 'package:cloud_video_app/app/data/services/auth_services.dart';
import 'package:cloud_video_app/app/modules/auths/login/login_screen.dart';
import 'package:cloud_video_app/app/modules/videos/videos/video_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final  _authProvider = Get.find<AuthProvider>();
  final AuthServices authService = AuthServices();

  late Future<bool> authenticationFuture;

  @override
  void initState() {
    super.initState();

    authenticationFuture = checkAuthentication();
  }

  Future<bool> checkAuthentication() async {
    final token = await _authProvider.authToken;

    print("Token: $token");

    if (token == null || token.isEmpty) {
      return false;
    }

    try {
      await authService.getCurrentUser();

      return true;
    } catch (e) {
      await _authProvider.reset();

      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: authenticationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.data == true) {
          return const VideoListScreen();
        }

        return LoginScreen();
      },
    );
  }
}