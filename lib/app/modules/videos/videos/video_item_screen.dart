import 'package:cloud_video_app/app/core/values/endpoints.dart';
import 'package:cloud_video_app/app/data/providers/auth_providers.dart';
import 'package:cloud_video_app/app/data/services/like_service.dart';
import 'package:cloud_video_app/app/data/services/share_service.dart';
import 'package:cloud_video_app/app/modules/users/user_profile_screen.dart' hide logger;
import 'package:cloud_video_app/app/modules/videos/videos/new_video/video_upload_screen.dart';
import 'package:cloud_video_app/app/modules/videos/widgets/comment_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoItemScreen extends StatefulWidget {

  final dynamic video;

  final bool isActive;

  final VoidCallback? onDelete;

  final VoidCallback? onUpdated;

  const VideoItemScreen({super.key, required this.video, required this.isActive, this.onDelete, this.onUpdated});

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

  final ShareService _shareService = ShareService();

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
                    
                    Get.to(() => const UserProfileScreen(userId: 5));
                  
                  },
                  
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 36,
                  ),
                
                ),
                IconButton(
                  onPressed: () async {
                    
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

                IconButton(
                  onPressed: () async {
                    
                    final videoId = widget.video['id'];

                    final videoUrl = widget.video['url']?.toString();

                    final shareUrl = '$appBaseUrl/videos/$videoId';

                    if (videoUrl == null || videoUrl.isEmpty) {
                      
                      logger.e('Video URL is missing or invalid');
                      
                      return;
                    
                    }

                    await _shareService.shareVideo(
                     
                      videoId: videoId,

                      title: widget.video['title'] ?? 'Video',
                    
                      videoUrl: shareUrl,
                   
                    );
                 
                  },
                 
                  icon: const Icon(
                 
                    Icons.share,
                 
                    color: Colors.white,
                 
                    size: 36,
                 
                  ),
                
                ),

                if (widget.onDelete != null && authProvider.user.user?.id == widget.video['user_id'])
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                    onSelected: (value) async {
                      if (value == 'edit') {
                        final updated = await Get.to(
                          () => VideoUploadScreen(
                            video: widget.video,
                          ),
                        );

                        if (updated == true) {
                          widget.onUpdated?.call();
                        }
                      }

                      if (value == 'delete') {
                        widget.onDelete!();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Modifier'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Supprimer'),
                      ),
                    ],
                  ),
              ],
            ),
          
          ),
            Positioned(
              bottom: 10,
              left: 30,
              right: 25,
              child: Text(
                  widget.video['title'] ?? '',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            
          
       
        ],
     
      ),
   
    );

  }

}