import 'package:cloud_video_app/app/data/services/api_service.dart';
import 'package:cloud_video_app/app/data/services/comment_service.dart';
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
  
  int likeCount = 0;

  int commentCount = 0;

  // final comment_sheet = CommentBottomSheet();
  
  
  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.video['url']))
      ..initialize().then((_) {
        
        setState(() {});
        
        if (widget.isActive) {
        
          _controller.play(); // autoplay
        
        }
       
        _controller.setLooping(true);
     
      });

      if (widget.isActive) {

      _controller.play();
      
    }

    likeCount = widget.video['likes_count'];

    

    // CommentService().addComment(videoId: 1, content: "Nouveau commentaire", userId: 1);
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

  dynamic toggleLike(int videoId) async {
    final apiService = Get.put(ApiService());
    final data = await apiService.toggleLike(widget.video['id']);

    print("Response de Data from toggle Like: ${data['liked']}");

    setState(() {
      
        isLiked = data['liked'] as bool;

        likeCount = data['likes_count'] as int;
   
    });

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
                  "$likeCount",
                  style: const TextStyle(color: Colors.white),
                ),
                SizedBox.shrink(),

                IconButton(

                  icon: const Icon(

                    Icons.comment,

                    color: Colors.white,

                    size: 36,

                  ),

                  onPressed: () {

                    showComments();

                  },
                ),

                Text(
                  "$commentCount",
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

// class CommentSheet extends StatelessWidget {
//   final String video;
//   const CommentSheet({super.key, required this.video});
// 
//   @override
//   
//   Widget build(BuildContext context) {
//     final api_service  = ApiService();
// 
//     final comments = api_service.getComments(video);
//     return SafeArea(
//      
//       child: SizedBox(
//      
//         height: MediaQuery.of(context).size.height * .7,
//      
//         child: Column(
//        
//           children: [
//        
//             const Padding(
//         
//               padding: EdgeInsets.all(16),
//          
//               child: Text(
//               
//                 "Commentaires",
//               
//                 style: TextStyle(
//               
//                   fontSize: 18,
//               
//                   fontWeight: FontWeight.bold,
//               
//                 ),
//              
//               ),
//            
//             ),
// 
//             const Divider(),
// 
//             Expanded(
//               
//               child: ListView.builder(
// 
//                 itemCount: 10,
// 
//                 itemBuilder: (_, index) {
// 
//                   return const ListTile(
// 
//                     leading: CircleAvatar(),
// 
//                     title: Text("Utilisateur"),
// 
//                     subtitle: Text("Très belle vidéo !"),
// 
//                   );
// 
//                 },
// 
//               ),
// 
//             ),
// 
//             Padding(
// 
//               padding: const EdgeInsets.all(12),
// 
//               child: Row(
// 
//                 children: [
// 
//                   Expanded(
// 
//                     child: TextField(
// 
//                       decoration: InputDecoration(
// 
//                         hintText: "Ajouter un commentaire...",
// 
//                         border: OutlineInputBorder(),
// 
//                       ),
// 
//                     ),
// 
//                   ),
// 
//                   IconButton(
// 
//                     icon: const Icon(Icons.send),
// 
//                     onPressed: () {
// 
//                     },
// 
//                   ),
// 
//                 ],
// 
//               ),
// 
//             )
// 
//           ],
// 
//         ),
// 
//       ),
// 
//     );
// 
//   }
// 
// }