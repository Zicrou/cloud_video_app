import 'package:cloud_video_app/app/data/providers/api_providers.dart';
import 'package:get/get.dart';

class VideoService {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  Future<List<dynamic>> getVideos() async {
    final data = await _apiProvider.get('/videos');

    return data as List<dynamic>;
  }
}