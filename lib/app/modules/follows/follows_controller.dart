import 'package:cloud_video_app/app/data/services/follow_service.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

final logger = Logger();
class FollowsController extends GetxController {
  final FollowService _followService = Get.find<FollowService>();

  final isFollowing = false.obs;
  final isLoading = false.obs;

  Future<void> loadFollowStatus(int userId) async {
    try {
      isLoading.value = true;

      final result = await _followService.getFollowStatus(userId);

      isFollowing.value = result['following'] == true;
    } catch (e, s) {
      logger.e(
        'Error loading follow status',
        error: e,
        stackTrace: s,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFollow(int userId) async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      if (isFollowing.value) {
        await _followService.unfollow(userId);

        isFollowing.value = false;
      } else {
        await _followService.follow(userId);

        isFollowing.value = true;
      }
    } catch (e, s) {
      logger.e(
        'Error toggling follow',
        error: e,
        stackTrace: s,
      );
    } finally {
      isLoading.value = false;
    }
  }
}