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
  
  late Future<List<dynamic>> commentsFuture;

  final controller = TextEditingController();

  final _commentService = Get.put(CommentService());

  @override

  void initState() {
    
    super.initState();

    commentsFuture = _commentService.getComments(widget.videoId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .7,
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
            const Divider(),

            // Liste des commentaires
            Expanded(
              child: FutureBuilder<List<dynamic>>(

                  future: commentsFuture,

                  builder: (context, snapshot) {

                    if (!snapshot.hasData) {

                      return const Center(

                        child: CircularProgressIndicator(),

                      );
                    }

                    final comments = snapshot.data!;

                    return ListView.builder(

                      itemCount: comments.length,

                      itemBuilder: (_, index) {

                        final comment = comments[index];

                        return ListTile(

                          leading: const CircleAvatar(),

                          title: Text(comment['user']['name']),

                          subtitle: Text(comment["comment"]),

                        );

                      },

                    );

                  },

                ),

            ),

            // Champ de saisie
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                    controller: controller,
                      decoration: const InputDecoration(
                        hintText: "Ajouter un commentaire...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () async {

                      print("Controller: ${controller.text}");
                      await _commentService.addComment(

                        videoId: widget.videoId,

                        content: controller.text.trim(),
                          
                      );

                      controller.clear();

                      setState(() {

                        commentsFuture = _commentService.getComments(widget.videoId);

                      });

                    },

                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
