import 'package:cloud_video_app/app/data/models/user.dart';

class UserRegister {
  User? user;
  String? token;

  UserRegister({this.user, this.token});

  UserRegister.fromJson(Map<String, dynamic> json) {
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
    // TODO: implement toString
    return "User: ${user}, Token: ${token}";
  }
}
