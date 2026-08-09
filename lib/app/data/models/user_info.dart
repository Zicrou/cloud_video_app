import 'package:cloud_video_app/app/data/models/user.dart';

class UserInfo {
  User? user;
  String? token;

  UserInfo({this.user, this.token});

  UserInfo.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    token = json['token'];
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['token'] = this.token;
    return data;
  }

  @override
  String toString() {
    return "User: ${user}, Token: ${token}";
  }
}
