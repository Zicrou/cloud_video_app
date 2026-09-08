import 'dart:convert';
import 'package:cloud_video_app/app/core/values/endpoints.dart';
import 'package:http/http.dart' as http;

class ApiService {

 

  static Future<List<dynamic>> getVideos() async {
    final response = await http.get(
      Uri.parse("$apiBaseUrl/videos"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load videos");
    }
  }

  

}