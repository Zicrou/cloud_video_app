import 'package:cloud_video_app/app/core/values/endpoints.dart';
import 'package:cloud_video_app/app/data/providers/api_providers.dart';
import 'package:get/get.dart';

import 'api_service.dart';

class CommentService {
    final ApiProvider _apiProvider = Get.find<ApiProvider>();


  Future<dynamic> getComments(int videoId) async {
    return await _apiProvider.get(
      '/videos/$videoId/comments',
    );
  }

  Future<dynamic> addComment({
    required int videoId,
    required String content,
  }) async {
    return await _apiProvider.post(
      '$baseUrl/comments', //$baseUrl/videos/$videoId/comments',
      {
        "video_id": videoId.toString(),
        "comment": content,
      },
    );
  }
}