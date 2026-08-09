// import 'package:cloud_video_app/app/modules/ventes/ventes/product_controller.dart';
// import 'package:cloud_video_app/view/product_tile.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:get/get.dart';

// class HomePage extends StatelessWidget {
//   final ProductController productController = Get.put(ProductController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         leading: Icon(Icons.arrow_back_ios),
//         actions: [
//           IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     'ShopX',
//                     style: TextStyle(
//                       fontFamily: 'avenir',
//                       fontSize: 32,
//                       fontWeight: FontWeight.w900,
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.view_list_rounded),
//                   onPressed: () {},
//                 ),
//                 IconButton(icon: Icon(Icons.grid_view), onPressed: () {}),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Obx(() {
//               if (productController.isLoading.value)
//                 return Center(child: CircularProgressIndicator());
//               else
//                 return MasonryGridView.count(
//                   crossAxisCount: 2,
//                   mainAxisSpacing: 16,
//                   crossAxisSpacing: 16,
//                   itemCount: productController.productList.length,
//                   itemBuilder: (context, index) {
//                     return ProductTile(productController.productList[index]);
//                   },
//                 );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }
