import 'package:cloud_video_app/app/data/services/follow_service.dart';
import 'package:cloud_video_app/app/modules/users/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

final logger = Logger();
class FollowUsersScreen extends StatefulWidget {
  final int userId;
  final bool showFollowers;

  const FollowUsersScreen({
    super.key,
    required this.userId,
    required this.showFollowers,
  });

  @override
  State<FollowUsersScreen> createState() => _FollowUsersScreenState();
}

class _FollowUsersScreenState extends State<FollowUsersScreen> {
  final FollowService _followService = Get.find<FollowService>();

  List<dynamic> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final result = widget.showFollowers
          ? await _followService.getFollowers(widget.userId)
          : await _followService.getFollowing(widget.userId);

      if (!mounted) return;

      setState(() {
        users = result;
        isLoading = false;
      });
    } catch (e, s) {
      logger.e(
        'Error loading users',
        error: e,
        stackTrace: s,
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.showFollowers
        ? 'Followers'
        : 'Following';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : users.isEmpty
              ? Center(
                  child: Text(
                    widget.showFollowers
                        ? 'Aucun follower'
                        : 'Aucun abonnement',
                  ),
                )
              : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];

                    return ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text(
                        user['name'] ?? 'Utilisateur',
                      ),
                      onTap: () {
                        Get.to(
                          () => UserProfileScreen(
                            userId: user['id'],
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}