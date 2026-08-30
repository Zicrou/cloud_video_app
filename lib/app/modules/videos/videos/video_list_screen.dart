import 'package:cloud_video_app/app/data/services/api_service.dart';
import 'package:cloud_video_app/app/data/services/comment_service.dart';
import 'package:cloud_video_app/app/data/services/video_service.dart';
import 'package:cloud_video_app/app/modules/auths/auth_controller.dart';
import 'package:cloud_video_app/app/modules/auths/login/login_screen.dart';
import 'package:cloud_video_app/app/modules/videos/videos/video_item_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  List videos = [];
  bool isLoading = true;
  
  final auth_controller = Get.find<AuthController>();
  final _videoServices = Get.put(VideoService());

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  void fetchVideos() async {
    final data = await _videoServices.getVideos();
    setState(() {
      videos = data;
      isLoading = false;
    });
  }

  int currentIndex = 0;

  void onPageChanged(int index) {
    
    setState(() {
     
      currentIndex = index;
   
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(
          "Liste des ventes",
          style: TextStyle(
            fontSize: 32,
            fontFamily: 'avenir',
            fontWeight: FontWeight.w900,
            color: Color.fromARGB(255, 0, 173, 253),
          ),
        ),

        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Déconnexion"),
                    content: Text(
                      "Êtes-vous sûr de vouloir vous déconnecter ?",
                    ),
                    actions: [
                      TextButton(
                        child: Text("Annuler"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text("Se déconnecter"),
                        onPressed: () async {
                          Navigator.of(context).pop(); // Close the dialog
                          await auth_controller.logout();
                          Get.to(() => LoginScreen());
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFFF5F5F5),

      
      body: isLoading
          
          ? const Center(
            
              child: CircularProgressIndicator(),
          
            )
         
          : PageView.builder(

          scrollDirection: Axis.vertical,

          itemCount: videos.length,

          onPageChanged: (index) {

            onPageChanged(index);

          },

          itemBuilder: (context, index) {

            return VideoItemScreen(

              video: videos[index],

              isActive: index == currentIndex,

            );

          },

        )

      );
  }
}