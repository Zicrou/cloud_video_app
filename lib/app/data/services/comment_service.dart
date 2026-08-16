import 'dart:convert';
import 'package:http/http.dart' as http;

class CommentService {

  static const baseUrl = "http://16.171.148.245/api";

  Future<List<dynamic>> getComments(int videoId) async {

    final response = await http.get(
      Uri.parse("$baseUrl/videos/$videoId/comments"),
    );
    print("Response de getComments dans comment service: ${response.body}");
    var resp =  jsonDecode(response.body);

    print("resp: $resp");
    return resp;
  }

  Future<void> addComment({
    required int videoId,
    required String content,
    required int userId
  }) async {
    print("VideoId: $videoId, content: $content, userID: $userId");
    final response = await http.post(
      Uri.parse("$baseUrl/comments"),
      body: {
        "video_id": videoId.toString(),
        "comment": content,
        "user_id": userId.toString(),
      },
    );

    print("Response: ${response.body}");
  }
}