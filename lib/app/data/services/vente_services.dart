// import 'package:cloud_video_app/app/data/models/user_info.dart';
// import 'package:cloud_video_app/app/data/models/user_register.dart';
// import 'package:cloud_video_app/app/data/models/vente_info.dart';
// import 'package:cloud_video_app/app/data/models/ventes.dart';
// import 'package:cloud_video_app/app/data/repositories/auth_repositories.dart';
// import 'package:cloud_video_app/app/data/repositories/ventes_repository.dart';
// import 'package:get/get.dart';
// import 'package:logger/logger.dart';

// final logger = Logger();

// class VenteServices extends GetxService {
//   //final _authProvider = Get.find<AuthProvider>();
//   final _venteServices = Get.find<VentesRepository>();

//   @override
//   void onInit() {
//     logger.w(
//       "Is AuthRepositories registered? ${Get.isRegistered<AuthRepositories>()}",
//     );
//     _venteServices;
//     super.onInit();
//   }

//   Future<VenteInfo> getAllVentes() async {
//     try {
//       // final response = await _dio.get('http://10.0.2.2:8000/api/V1/ventes');
//       return await _venteServices.listVentes();
//     } catch (e) {
//       throw Exception("Error fetching ventes: $e");
//     }
//   }

//   createVente(Map<String, dynamic> json) async {
//     //return await _venteServices.createVente();
//   }

//   // ListVentes() async {
//   //   logger.i('AuthService: Fetching list of ventes');
//   //   return await _authRepository.listVentes();
//   // }
// }
