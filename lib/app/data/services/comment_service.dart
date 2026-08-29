import 'package:cloud_video_app/app/core/values/endpoints.dart';
import 'package:cloud_video_app/app/data/providers/api_providers.dart';
import 'package:cloud_video_app/app/data/providers/auth_providers.dart';
import 'package:get/get.dart';


class CommentService {
      
  final ApiProvider _apiProvider = Get.put(ApiProvider());


  Future<List<dynamic>> getComments(int videoId) async {
    
    final data = await _apiProvider.get(
      
      '$baseUrl/videos/$videoId/comments',
    );
    print('COMMENTS DATA: $data');
  
    print('COMMENTS TYPE: ${data.runtimeType}');

    return data as List<dynamic>;

  }

  Future<dynamic> addComment({
    required int videoId,
    required String content,
  }) async {
    print("Adding comment: $content");
    return await _apiProvider.post(
      '$baseUrl/videos/$videoId/comments',
      {
        "comment": content,
      },
    );
  }
}