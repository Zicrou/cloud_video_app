import 'package:cloud_video_app/app/initial_bindings.dart';
import 'package:cloud_video_app/app/modules/login/login_screen.dart';
import 'package:cloud_video_app/app/modules/videos/videos/video_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
     
      ),

      initialBinding: AppInitialBindings(),
      
      home: LoginScreen(),
      //const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

