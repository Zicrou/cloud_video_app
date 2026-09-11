import 'package:cloud_video_app/app/core/values/endpoints.dart';
import 'package:cloud_video_app/app/data/providers/api_providers.dart';
import 'package:get/get.dart';

class FollowService {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  Future<Map<String, dynamic>> follow(int userId) async {
    final response = await _apiProvider.post(
      '$apiBaseUrl/users/$userId/follow',
      {},
    );

    return response as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> unfollow(int userId) async {
    final response = await _apiProvider.delete(
      '$apiBaseUrl/users/$userId/follow',
    );

    return response as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFollowStatus(int userId) async {
    final response = await _apiProvider.get(
      '$apiBaseUrl/users/$userId/follow-status',
    );

    return response as Map<String, dynamic>;
  }

  Future<List<dynamic>> getFollowers(int userId) async {
    final response = await _apiProvider.get(
      '$apiBaseUrl/users/$userId/followers',
    );

    return response as List<dynamic>;
  }

  Future<List<dynamic>> getFollowing(int userId) async {
    final response = await _apiProvider.get(
      '$apiBaseUrl/users/$userId/following',
    );

    return response as List<dynamic>;
  }

  Future<Map<String, dynamic>> getUser(int userId) async {
    final response = await _apiProvider.get(
      '$apiBaseUrl/users/$userId',
    );

    return response as Map<String, dynamic>;
  }

  Future<List<dynamic>> getUserVideos(int userId) async {
    final response = await _apiProvider.get(
      '$apiBaseUrl/users/$userId/videos',
    );
    return response as List<dynamic>;
  }
}