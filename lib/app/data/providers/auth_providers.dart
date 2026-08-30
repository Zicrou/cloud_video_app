import 'package:cloud_video_app/app/data/models/user.dart';
import 'package:cloud_video_app/app/data/models/user_register.dart';
import 'package:cloud_video_app/app/data/providers/storage_providers.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart';

import '../models/user_info.dart';

final logger = Logger();

class AuthProvider extends GetxService {
  
  final _storageProvider = Get.find<StorageProvider>();
  
  final _user = UserInfo().obs;
  
  final _userRegister = UserRegister().obs;
  
  final _isAuthenticated = false.obs;
  
  final _authToken = ''.obs;
  
  final _refreshToken = ''.obs;
  
  final _userId = ''.obs;
  
  final deviceId = ''.obs;
  
  final _fcmToken = ''.obs;

  bool get isAuthenticated => _isAuthenticated.value;
  String get fcmToken => _fcmToken.value;
  String get authToken => _authToken.value;

  set fcmToken(String value) {
    _fcmToken.value = value;
  }

  set authToken(String value) {
    _authToken.value = value;
    _storageProvider.authToken = value;
  }

  get refreshToken => _refreshToken.value;

  set refreshToken(value) {
    _refreshToken.value = value;
    _storageProvider.refreshToken = value;
  }

  UserRegister get userRegister => _userRegister.value;
  set userRegister(UserRegister userRegister) {
    _userRegister.value = userRegister;
  }

  UserInfo get user => _user.value;
  set user(UserInfo user) {
    _user.value = user;
    logger.i('userId: ${user.user}');

    if (user.user!.id != null) {
      _userId.value = user.user!.id.toString();
    }
  }

  set isAuthenticated(value) {
    _isAuthenticated.value = value;
    _storageProvider.authStatus = value;
  }

  reset() {
    isAuthenticated = false;
    authToken = '';
    //user = UserInfo();
  }

  @override
  void onInit() {
    super.onInit();
    //getDeviceId();
    _isAuthenticated.value = _storageProvider.authStatus ?? false;
    _authToken.value = _storageProvider.authToken ?? '';
    _refreshToken.value = _storageProvider.refreshToken ?? '';

    if (isAuthenticated) {
      logger.i('authToken : $authToken');
    }
  }

  // Future<void> getDeviceId() async {
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   String id = '';

  //   if (Platform.isAndroid) {
  //     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //     id = androidInfo.id;
  //   } else if (Platform.isIOS) {
  //     IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  //     id = iosInfo.identifierForVendor!;
  //   }
  //   deviceId.value = id;
  // }
}
