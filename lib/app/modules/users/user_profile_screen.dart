import 'dart:io';

import 'package:cloud_video_app/app/data/services/follow_service.dart';
import 'package:cloud_video_app/app/data/services/video_thumbnail_service.dart';
import 'package:cloud_video_app/app/modules/follows/follow_users_screen.dart';
import 'package:cloud_video_app/app/modules/follows/follows_controller.dart';
import 'package:cloud_video_app/app/modules/videos/videos/video_item_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

final logger = Logger();
class UserProfileScreen extends StatefulWidget {
  final int userId;

  const UserProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final FollowService _followService = Get.find<FollowService>();

  late final FollowsController _followController;

  String userName = '';
  int followersCount = 0;
  int followingCount = 0;
  bool isMe = false;

  bool isLoadingProfile = true;

  List<dynamic> videos = [];
  bool isLoadingVideos = true;

  final VideoThumbnailService _thumbnailService =
    VideoThumbnailService();

  @override
  void initState() {
    super.initState();

    _followController = Get.put(
      FollowsController(),
      tag: 'user_${widget.userId}',
    );

    _loadProfile();
    _loadVideos();
  }

  Future<void> _loadProfile() async {
    try {
      final response = await _followService.getUser(widget.userId);

      if (!mounted) return;

      setState(() {
        userName = response['name'] ?? '';
        followersCount = response['followers_count'] ?? 0;
        followingCount = response['following_count'] ?? 0;
        isMe = response['is_me'] == true;
      });

      _followController.isFollowing.value =
          response['is_following'] == true;
    } catch (e, s) {
      logger.e(
        'Error loading user profile',
        error: e,
        stackTrace: s,
      );
    } finally {
      if (!mounted) return;

      setState(() {
        isLoadingProfile = false;
      });
    }
  }

  Future<void> _toggleFollow() async {
    final wasFollowing = _followController.isFollowing.value;

    await _followController.toggleFollow(widget.userId);

    if (!mounted) return;

    if (wasFollowing != _followController.isFollowing.value) {
      setState(() {
        if (_followController.isFollowing.value) {
          followersCount++;
        } else {
          followersCount--;
        }
      });
    }
  }

  @override
  void dispose() {
    Get.delete<FollowsController>(
      tag: 'user_${widget.userId}',
    );

    super.dispose();
  }

  Future<void> _loadVideos() async {
    try {
      final result = await _followService.getUserVideos(
        widget.userId,
      );

      if (!mounted) return;

      setState(() {
        videos = result;
        isLoadingVideos = false;
      });
    } catch (e, s) {
      logger.e(
        'Error loading user videos',
        error: e,
        stackTrace: s,
      );

      if (!mounted) return;

      setState(() {
        isLoadingVideos = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingProfile) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(userName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(
                Icons.person,
                size: 50,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              userName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(
                      () => FollowUsersScreen(
                        userId: widget.userId,
                        showFollowers: true,
                      ),
                    );
                  },
                  child: _statItem(
                    count: followersCount,
                    label: 'Followers',
                  ),
                ),
                

                const SizedBox(width: 40),

                GestureDetector(
                  onTap: () {
                    Get.to(
                      () => FollowUsersScreen(
                        userId: widget.userId,
                        showFollowers: false,
                      ),
                    );
                  },
                  child: _statItem(
                    count: followingCount,
                    label: 'Following',
                  ),
                ),
                
              ],
            ),

            const SizedBox(height: 24),

            if (!isMe)
              Obx(() {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _followController.isLoading.value
                        ? null
                        : _toggleFollow,
                    child: _followController.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            _followController.isFollowing.value
                                ? 'Following'
                                : 'Follow',
                          ),
                  ),
                );
              }),
              const SizedBox(height: 30),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Vidéos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: _buildVideos(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _statItem({
    required int count,
    required String label,
  }) {
    return Column(
      children: [
        Text(
          '$count',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label),
      ],
    );
  }

  Widget _buildVideos() {
    if (isLoadingVideos) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (videos.isEmpty) {
      return const Center(
        child: Text(
          'Aucune vidéo',
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 0.7,
      ),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];

        return GestureDetector(
          onTap: () {
            Get.to(
              () => VideoItemScreen(
                video: video,
                isActive: true,
              ),
            );
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildVideoThumbnail(video),

              const Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.play_circle_outline,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVideoThumbnail(
    Map<String, dynamic> video,
  ) {
    final videoUrl = video['url'] as String;

    return FutureBuilder<File?>(
      future: _thumbnailService.generateThumbnail(videoUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return const Center(
            child: Icon(
              Icons.video_library,
              size: 40,
            ),
          );
        }

        return Image.file(
          snapshot.data!,
          fit: BoxFit.cover,
        );
      },
    );
  }
}