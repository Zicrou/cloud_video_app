import 'package:cloud_video_app/app/data/providers/api_providers.dart';
import 'package:cloud_video_app/app/data/providers/auth_providers.dart';
import 'package:cloud_video_app/app/data/providers/storage_providers.dart';
import 'package:cloud_video_app/app/data/repositories/auth_repositories.dart';
import 'package:cloud_video_app/app/data/services/auth_services.dart';
import 'package:cloud_video_app/app/modules/auths/auth_controller.dart';
// import 'package:cloud_video_app/app/modules/journaux/journal_controller.dart';
import 'package:get/get.dart';

class AppInitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(StorageProvider(), permanent: true);
    Get.put(AuthProvider(), permanent: true);
    Get.put(ApiProvider());
    Get.put(AuthRepositories()); // MUST come before AuthServices
    Get.lazyPut(() => AuthServices());
    // safe to find dependencies
    Get.put(AuthController());
  }
}
