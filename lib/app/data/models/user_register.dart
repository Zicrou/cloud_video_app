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
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['token'] = token;
    return data;
  }

  @override
  String toString() {
   
    return "User: $user, Token: $token";

  }
}
