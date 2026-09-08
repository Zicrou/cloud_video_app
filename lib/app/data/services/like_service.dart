import 'package:cloud_video_app/app/core/values/endpoints.dart';
import 'package:cloud_video_app/app/data/providers/api_providers.dart';
import 'package:get/get.dart';


class LikeService {
      
  final ApiProvider _apiProvider = Get.put(ApiProvider());

  Future<dynamic> toggleLike(int videoId) async {
  
      
    var response = await _apiProvider.post("$apiBaseUrl/videos/$videoId/likes",{});

    return response;

  }

  Future<Map<String, dynamic>> getLikeStatus(int videoId) async {
   
    final response = await _apiProvider.get(
    
      '$apiBaseUrl/videos/$videoId/likes',
   
    );

    return response as Map<String, dynamic>;

  }

}