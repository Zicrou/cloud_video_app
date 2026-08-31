import 'package:cloud_video_app/app/core/values/endpoints.dart';
import 'package:cloud_video_app/app/data/providers/api_providers.dart';
import 'package:cloud_video_app/app/data/providers/auth_providers.dart';
import 'package:get/get.dart';


class LikeService {
      
  final ApiProvider _apiProvider = Get.put(ApiProvider());

  final _authProvider = Get.find<AuthProvider>();

  Future<dynamic> toggleLike(int videoId) async {
  
    print("Video ID: $videoId");
      
    var response = await _apiProvider.post("$baseUrl/videos/$videoId/likes",{});

    print("Response de toggleLike: $response");
    
    print("Response['liked'] de toggleLike: ${response['liked']}");

    return response;

  }

  Future<Map<String, dynamic>> getLikeStatus(int videoId) async {
   
    final response = await _apiProvider.get(
    
      '$baseUrl/videos/$videoId/likes',
   
    );

    return response as Map<String, dynamic>;

  }

}