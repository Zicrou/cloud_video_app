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

  

}