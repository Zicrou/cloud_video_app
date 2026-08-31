import 'package:cloud_video_app/app/data/providers/auth_providers.dart';
import 'package:cloud_video_app/app/data/services/api_service.dart';
import 'package:cloud_video_app/app/data/services/auth_services.dart' hide logger;
import 'package:cloud_video_app/app/data/services/comment_service.dart';
import 'package:cloud_video_app/app/data/services/like_service.dart';
import 'package:cloud_video_app/app/data/services/video_service.dart';
import 'package:cloud_video_app/app/modules/videos/widgets/comment_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:video_player/video_player.dart';

class VideoItemScreen extends StatefulWidget {

  final dynamic video;

  final bool isActive;

  const VideoItemScreen({super.key, required this.video, required this.isActive});

  @override
  State<VideoItemScreen> createState() => _VideoItemScreenState();
}

class _VideoItemScreenState extends State<VideoItemScreen> {
  
  late VideoPlayerController _controller;
  
  bool isLiked = false;
  
  int likesCount = 0;

  int commentCount = 0;

  final AuthProvider authProvider = Get.find<AuthProvider>();

  final _likeService = Get.put(LikeService());

  @override
  void initState() {
    super.initState();

    likesCount = widget.video['likes_count'];

    loadLikeStatus();

    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.video['url']))
      ..initialize().then((_) {
        
        if (!mounted) return;

        setState(() {});
        
        if (widget.isActive) {
        
          _controller.play(); // autoplay
        
        }
       
        _controller.setLooping(true);
     
      });

      if (widget.isActive) {

      _controller.play();
      
    }

  }

  @override
  void didUpdateWidget(covariant VideoItemScreen oldWidget) {
    
    super.didUpdateWidget(oldWidget);

    if (widget.isActive) {
    
      _controller.play();
   
    } else {
   
      _controller.pause();
   
    }

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> toggleLike(int videoId) async {
    try{

      final data = await _likeService.toggleLike(videoId);

      print("Response: $data");

      print("Liked: ${data['liked']}");
      
      print("Likes count: ${data['likes_count']}");

      if (!mounted) return;

      setState(() {
       
        isLiked = data['liked'] == true;
       
        likesCount = data['likes_count'] ?? 0;
     
      });

    } catch (e) {

      logger.e('Toggle like error: $e');
      
    }

  }

  void showComments() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) {
      return CommentBottomSheet(
        videoId: widget.video['id'],
      );
    },
  );
}

  void _togglePlayPause() {
   
    if (_controller.value.isPlaying){
           
      _controller.pause();

    }

    _controller.play();

  }

  Future<void> loadLikeStatus() async {
    try {
      
        final response = await _likeService
          .getLikeStatus(widget.video['id']);

      
        if (!mounted) return;

        setState(() {
         
          isLiked = response['liked'] == true;
        
          likesCount = response['likes_count'] ?? 0;
       
        });
   
    } catch (e) {
    
      logger.e('Error loading like status: $e');
   
    }
 
  }

  @override
  Widget build(BuildContext context) {

    if (!_controller.value.isInitialized) {

      return const Center(child: CircularProgressIndicator());

    }


    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        children: [
          // La vidéo
          Positioned.fill(
            child: SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
          ),

          // Les boutons
          Positioned(
            right: 16,
            bottom: 120,
            child: Column(
              children: [
                IconButton(
                  onPressed: () async {
                    
                    print("Video id: ${widget.video['id']}");
                    
                    await toggleLike(widget.video['id']);
                  
                  },
                  
                  icon: Icon(
                  
                    isLiked
                   
                        ? Icons.favorite
                   
                        : Icons.favorite_border,
                   
                    color: Colors.white,
                  
                    size: 36,
                 
                  ),
                
                ),

                Text(
                  "$likesCount",
                  style: const TextStyle(color: Colors.white),
                ),
                SizedBox.shrink(),

                IconButton(

                  icon: const Icon(

                    Icons.comment,

                    color: Colors.white,

                    size: 36,

                  ),

                  onPressed: () async {
                
                    showComments();

                  },
                ),

                Text(
                  "${widget.video['comments_count']}",
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }

}