import 'dart:io';

import 'package:cloud_video_app/app/core/values/endpoints.dart';
import 'package:cloud_video_app/app/data/providers/api_providers.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide MultipartFile;


class VideoUploadService {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  Future<Map<String, dynamic>> uploadVideo({
    required String title,
    required File videoFile,
    required void Function(int sent, int total) onProgress,
  }) async {
    final response = await _apiProvider.postFormData(
      '$apiBaseUrl/videos',
      {
        'title': title,
        'video': await MultipartFile.fromFile(
          videoFile.path,
          filename: videoFile.path.split('/').last,
        ),
      },
      onSendProgress: onProgress,
    );

    return response as Map<String, dynamic>;
  }
}