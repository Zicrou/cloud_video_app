class CommentModel {
  final int id;

  final int videoId;

  final String content;

  final String userName;

  CommentModel({

    required this.id,

    required this.videoId,

    required this.content,

    required this.userName,

  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    
    return CommentModel(
     
      id: json['id'],
     
      videoId: json['video_id'],
     
      content: json['content'],
     
      userName: json['user_name'] ?? 'Anonymous',
  
   );
 
  }

}
