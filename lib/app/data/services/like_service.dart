import 'package:cloud_video_app/app/core/values/endpoints.dart';
import 'package:cloud_video_app/app/data/providers/api_providers.dart';
import 'package:cloud_video_app/app/data/providers/auth_providers.dart';
import 'package:get/get.dart';


class LikeService {
      
  final ApiProvider _apiProvider = Get.put(ApiProvider());

  final _authProvider = Get.find<AuthProvider>();

  Future<dynamic> toggleLike(int videoId) async {
  
    var token = _authProvider.authToken;
     
    print("Data: $videoId");
      
    var response = await _apiProvider.post("$baseUrl/videos/$videoId/likes",{});

    print("Response de toggleLike de Api Service: ${response['liked']}");
    
    print("Response['liked'] de toggleLike de Api Service: ${response['liked']}");

    return response;

  }

  Future<bool> isLiked(int videoId) async {
   
    final response = await _apiProvider.get(
     
      '$baseUrl/videos/$videoId/likes/isLiked',
   
    );

    return response['liked'] == true;

  }

}