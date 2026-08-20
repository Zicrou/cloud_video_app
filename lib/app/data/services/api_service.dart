import 'dart:convert';
import 'package:cloud_video_app/app/core/values/endpoints.dart';
import 'package:cloud_video_app/app/data/providers/api_providers.dart';
import 'package:cloud_video_app/app/data/providers/auth_providers.dart';
import 'package:http/http.dart' as http;

class ApiService {

  final auth_provider = AuthProvider();

  final apiProvider = ApiProvider();


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

  Future<dynamic> toggleLike(int videoId) async {
  
  var token = auth_provider.authToken;
     print("Data: $videoId");
      var response = await apiProvider.post("$baseUrl/videos/$videoId/likes",{});
        
      

    print("Response de toggleLike de Api Service: ${response['liked']}");
    
    print("Response['liked'] de toggleLike de Api Service: ${response['liked']}");


    return response;

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