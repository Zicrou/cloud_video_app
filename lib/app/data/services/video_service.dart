import 'package:cloud_video_app/app/core/values/endpoints.dart';
import 'package:cloud_video_app/app/data/providers/api_providers.dart';
import 'package:cloud_video_app/app/data/providers/auth_providers.dart';
import 'package:get/get.dart';

class VideoService {
  
  final auth_provider = AuthProvider();

  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  Future<List<dynamic>> getVideos() async {
    final data = await _apiProvider.get('$baseUrl/videos');
    return data as List<dynamic>;
  }

}