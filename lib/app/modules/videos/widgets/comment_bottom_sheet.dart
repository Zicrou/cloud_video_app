import 'package:cloud_video_app/app/core/interceptors/api_interceptors.dart';
import 'package:cloud_video_app/app/data/providers/auth_providers.dart' hide logger;
import 'package:cloud_video_app/app/data/services/comment_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentBottomSheet extends StatefulWidget {
  final int videoId;

  const CommentBottomSheet({
    super.key,
    required this.videoId,
  });

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  
  final controller = TextEditingController();

  final _commentService = Get.put(CommentService());

  List<dynamic> comments = [];
  
  bool isLoadingComments = true;

  final FocusNode commentFocusNode = FocusNode();

  final TextEditingController _commentControllerTextEditingController =
      TextEditingController();

  final ScrollController scrollController =
      ScrollController();

  Map<String, dynamic>? replyingTo;

  final _authProvider = Get.find<AuthProvider>();

  @override

  void initState() {
    
    super.initState();

    loadComments();


  }

  Future<void> loadComments() async {
    try {
     
      final data = await _commentService.getComments(widget.videoId);

      if (!mounted) return;

      setState(() {
       
        comments = data;
       
        isLoadingComments = false;
     
      });
    } catch (e) {
      
      logger.e('Error loading comments: $e');

      if (!mounted) return;

      setState(() {

        isLoadingComments = false;

      });

    }

  }

String formatCommentDate(String? date) {
  
  if (date == null) {
  
    return '';
  
  }

  final createdAt = DateTime.parse(date);
  
  final now = DateTime.now();

  final difference = now.difference(createdAt);

  if (difference.inSeconds < 60) {
    
    return 'Il y a quelques secondes';

  }

  if (difference.inMinutes < 60) {

    return 'Il y a ${difference.inMinutes} min';

  }

  if (difference.inHours < 24) {

    return 'Il y a ${difference.inHours} h';

  }

  if (difference.inDays < 7) {

    return 'Il y a ${difference.inDays} j';

  }

  return '${createdAt.day}/${createdAt.month}/${createdAt.year}';

}

@override
  
  void dispose() {
   
    controller.dispose();
   
    scrollController.dispose();

    super.dispose();
  }


  Future<void> deleteComment(
    
    Map<String, dynamic> comment,
  
  ) async {
   
    final commentId = comment['id'];

    try {
    
      await _commentService.deleteComment(commentId);

      if (!mounted) return;
    
      setState(() {
    
        comments.removeWhere(
    
          (item) => item['id'] == commentId,
    
        );
    
      });

    } catch (e) {
    
      logger.e(
        'Error deleting comment: $e',
      );
    }
  }

  Future<void> confirmDeleteComment(
   
    Map<String, dynamic> comment,
 
  ) async {
   
    final confirmed = await showDialog<bool>(
   
     context: context,
   
      builder: (context) {
   
        return AlertDialog(
   
          title: const Text(
   
            'Supprimer le commentaire ?',
   
          ),
   
          content: const Text(
   
            'Cette action est irréversible.',
   
          ),
   
          actions: [
   
            TextButton(
   
              onPressed: () {
   
               Navigator.pop(context, false);
   
              },
   
              child: const Text('Annuler'),
   
            ),
   
            TextButton(
   
              onPressed: () {
   
                Navigator.pop(context, true);
   
              },
   
              child: const Text('Supprimer'),
   
            ),

         ],

        );

      },

    );

    if (confirmed == true) {
      await deleteComment(comment);
    }
  }

  void replyToComment(
   
    Map<String, dynamic> comment,
  
  ) {
  
    setState(() {
  
      replyingTo = comment;
  
    });

    _commentControllerTextEditingController.clear();

    commentFocusNode.requestFocus();
  }

  Future<void> deleteReply(Map<String, dynamic> reply) async {

    print('Deleting reply: $reply');

    final replyId = reply['id'];

    try {
     
      await CommentService().deleteComment(replyId);

    print('Reply deleted successfully: $replyId');

      if (!mounted) return;

      setState(() {
        for (final comment in comments) {
          final replies = comment['replies'];

          if (replies is List) {
            
            print('Removing reply with ID: $replyId from comment ID: ${comment['id']}');
          
            replies.removeWhere(
              (item) => item['id'] == replyId,
            );

            print('Updated replies for comment ID: ${comment['id']}: $replies');
          }
        }
      });
    } catch (e) {
      logger.e('Error deleting reply: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
    padding: EdgeInsets.only(
      bottom: MediaQuery.of(context).viewInsets.bottom,
    ),
    
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .75,
        child: Column(
          children: [

            // Header
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Commentaires",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Divider
            const Divider(height: 1),

            // Liste des commentaires
            Expanded(
              child: isLoadingComments

                  ? const Center(
                   
                      child: CircularProgressIndicator(),
                   
                    )
                 
                : ListView.builder(

                        controller: scrollController,

                        padding: const EdgeInsets.symmetric(vertical: 8,),
                     
                          itemCount: comments.length,
                      
                          itemBuilder: (context, index) {
                      
                            final comment = comments[index];
                            
                            return buildComment(comment);

                          }
                 
                  ),
                            
                ),

            // Champ de saisie
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(8),
                  child: Column(

                    children: [

                      if (replyingTo != null) ...[
                        
                        Container(
                        
                          padding: const EdgeInsets.symmetric(
                        
                            horizontal: 12,
                        
                            vertical: 8,
                        
                          ),
                        
                          child: Row(
                        
                            children: [
                        
                              Expanded(
                        
                                child: Text(
                        
                                  'Réponse à ${replyingTo!['user']?['name'] ?? 'Utilisateur'}',
                        
                                ),
                        
                              ),

                              IconButton(
                          
                                icon: const Icon(Icons.close),
                            
                                onPressed: () {
                            
                                  setState(() {
                            
                                    replyingTo = null;
                            
                                  });

                                  _commentControllerTextEditingController.clear();
                              
                                },
                            
                              ),
                           
                            ],
                         
                          ),
                       
                        ),
                    
                      ],

                      Row(
                      
                        children: [
                      
                          Expanded(
                      
                            child: TextField(
                      
                              controller: _commentControllerTextEditingController,
                            
                              focusNode: commentFocusNode,
                            
                              maxLines: null,
                            
                              decoration: InputDecoration(
                            
                                hintText: replyingTo != null
                            
                                    ? 'Écrire une réponse...'
                            
                                    : 'Ajouter un commentaire...',
                            
                              ),
                            
                            ),
                         
                          ),

                          IconButton(
                          
                            icon: const Icon(Icons.send),
                          
                            onPressed: () async {
                              
                              final content = _commentControllerTextEditingController.text.trim();

                              if (content.isEmpty) {
                               
                                return;
                              
                              }

                              try {
                                
                                final newComment =
                                    await CommentService().addComment(
                                 
                                  videoId: widget.videoId,
                                
                                  content: content,
                                
                                  parentId: replyingTo?['id'],
                                );

                                if (!mounted) return;

                                setState(() {
                                 
                                  if (replyingTo != null) {

                                    final parent = comments.firstWhere(
                                   
                                      (comment) => comment['id'] == replyingTo!['id'],
                                  
                                    );

                                    parent['replies'] ??= [];

                                    parent['replies'].insert(
                                    
                                      0,
                                    
                                      newComment,
                                   
                                    );

                                  } else {

                                    comments.insert(
                                   
                                      0,
                                   
                                      newComment,
                                 
                                    );
                                
                                  }

                                  replyingTo = null;
                               
                                });

                                _commentControllerTextEditingController.clear();

                              } catch (e) {
                               
                                logger.e(
                                  
                                  'Error adding comment/reply: $e',
                              
                                );
                             
                              }
                           
                            },
                         
                          ),
                       
                        ],
                     
                      ),
                   
                    ],
                 
                  )
                    
              )
            
            )
         
          ]
       
        ),
     
      ),
   
    );
 
  }

  Widget buildComment(
    Map<String, dynamic> comment,
  ) {
    final user = comment['user'];

    final replies = (comment['replies'] ?? []) as List<dynamic>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.person),
          ),

          title: Text(
           
            user?['name'] ?? 'Utilisateur',
            
            style: const TextStyle(
             
              fontWeight: FontWeight.bold,
          
            ),
         
          ),

          subtitle: Text(
         
            comment['comment'] ?? '',
         
          ),

          trailing: PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'reply') {
                replyToComment(comment);
              }

              if (value == 'delete') {
                confirmDeleteComment(comment);
              }
            },

            itemBuilder: (context) {
              final currentUserId =
                  _authProvider.user.user?.id;

              final commentUserId =
                  user?['id'];

              final isOwner = commentUserId == currentUserId;

              return [
                const PopupMenuItem(
                  value: 'reply',
                  child: Text('Répondre'),
                ),

                if (isOwner)
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Supprimer'),
                  ),
              ];
            },
          ),
        ),

        if (replies.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(
              left: 56,
            ),
            child: Column(
              children: replies.map<Widget>(
                (reply) {
                  return buildReply(reply);
                },
              ).toList(),
            ),
          ),
      ],
    );
  }

  Widget buildReply(
    Map<String, dynamic> reply,
  ) {
    final user = reply['user'];

    return ListTile(
      contentPadding: EdgeInsets.zero,

      leading: const CircleAvatar(
        radius: 16,
        child: Icon(
          Icons.person,
          size: 18,
        ),
      ),

      title: Text(
        user?['name'] ?? 'Utilisateur',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),

      subtitle: Text(
        reply['comment'] ?? '',
      ),

      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'reply') {
            replyToComment(reply);
          }

          if (value == 'delete') {
            confirmDeleteReply(reply);
          }
        },

        itemBuilder: (context) {
          final currentUserId =
              _authProvider.user.user?.id;

          final replyUserId =
              user?['id'];

          final isOwner =
              replyUserId == currentUserId;

          return [
            const PopupMenuItem(
              value: 'reply',
              child: Text('Répondre'),
            ),

            if (isOwner)
              const PopupMenuItem(
                value: 'delete',
                child: Text('Supprimer'),
              ),
          ];
        },
      ),
    );
  }

  Future<void> confirmDeleteReply( Map<String, dynamic> reply) async {
   
    final confirmed = await showDialog<bool>(
     
      context: context,
     
      builder: (context) {
     
        return AlertDialog(
     
          title: const Text('Supprimer la réponse ?'),
     
          content: const Text(
     
            'Cette action est irréversible.',
     
          ),
     
          actions: [
     
            TextButton(
     
              onPressed: () {
     
                Navigator.pop(context, false);
     
              },
     
              child: const Text('Annuler'),
     
            ),
     
            TextButton(
     
              onPressed: () {
     
                Navigator.pop(context, true);
     
              },
     
              child: const Text('Supprimer'),
     
            ),
     
          ],
     
        );
     
      },
   
    );

    if (confirmed == true) {
      
      await deleteReply(reply);
   
    }
 
  }
}
