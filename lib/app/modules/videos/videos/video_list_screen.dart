import 'package:cloud_video_app/app/data/services/api_service.dart';
import 'package:cloud_video_app/app/modules/videos/videos/video_item_screen.dart';
import 'package:flutter/material.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  List videos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  void fetchVideos() async {
    final data = await ApiService.getVideos();
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

        title: const Text("Videos"),
      
      ),
      
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