import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://16.171.148.245/api";

  static Future<List<dynamic>> getVideos() async {
    final response = await http.get(
      Uri.parse("$baseUrl/videos"),
    );

    print("Response de getVideos de ApiService: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load videos");
    }
  }

  Future<dynamic> toggleLike(String videoId) async {
  
    var response = await http.post(
      
      Uri.parse('$baseUrl/like'),
      
      body: {
      
        "video_id": videoId,
      
        "user_id": "1",
      
      },

    );

    print("Response de toggleLike de Api Service: ${response.body}");
    
   final res = jsonDecode(response.body);

    print("Response.body de toggleLike de Api Service: $res['liked]");


    return res;

  }

  Future<void> getComments(String videoId) async {
  
    var response = await http.get(
      
      Uri.parse('$baseUrl/comments/$videoId'),

    );

    print("Response de getComment de Api Service: ${response.body}");
    
   final res = jsonDecode(response.body);

    print("Response.body de getComment de Api Service: $res");


    return res;

  }

  Future<dynamic> addComment(String videoId, String text) async {
  
    var response = await http.post(
      
      Uri.parse('$baseUrl/comments/'),

      body: {

        "video_id": videoId,

        "comment": text,
      },
    );

    print("Response de addComment de Api Service: ${response.body}");
    
   final res = jsonDecode(response.body);

    print("Response.body de addComment de Api Service: $res['success']");


    return res;

  }

}