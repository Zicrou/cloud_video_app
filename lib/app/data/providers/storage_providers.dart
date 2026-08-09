import 'package:cloud_video_app/app/core/values/storage_keys.dart';
import 'package:get_storage/get_storage.dart';

class StorageProvider {
  final appStorage = GetStorage();

  Future<String?> readToken() async {
    var readToken = await appStorage.read(authTokenKey);
    return readToken;
  }

  bool? get authStatus => appStorage.read(authStatusKey);

  set refreshToken(String? value) {
    appStorage.write(refreshTokenKey, value);
  }

  String? get refreshToken => appStorage.read(refreshTokenKey);

  set authStatus(bool? value) {
    appStorage.write(authStatusKey, value);
  }

  String? get authToken => appStorage.read(authTokenKey);

  set authToken(String? value) {
    appStorage.write(authTokenKey, value);
  }

  bool? get seenOnBoarding => appStorage.read(seenOnBoardingKey);

  set seenOnBoarding(bool? value) {
    appStorage.write(seenOnBoardingKey, value);
  }
}
