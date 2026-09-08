import 'package:cloud_video_app/app/core/values/app_colors.dart';
import 'package:cloud_video_app/app/core/values/dimens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

dynamic errorMessage(String textMsg) {
  Get.snackbar(
    'Message',
    textMsg,
    colorText: AppColors.whiteColor,
    backgroundColor: AppColors.errorColor,
    snackPosition: SnackPosition.TOP,
    duration: Duration(seconds: 3),
    icon: Icon(Icons.error_outline, color: AppColors.whiteColor, size: 20),
  );
}

dynamic goodMessage(String textMsg) {
  Get.snackbar(
    'Message',
    textMsg,
    colorText: AppColors.whiteColor,
    backgroundColor: AppColors.primaryColor,
    snackPosition: SnackPosition.TOP,
    duration: Duration(seconds: 5),
    icon: Icon(
      Icons.notifications_active_outlined,
      color: AppColors.whiteColor,
      size: Dimens.x4lSize,
    ),
  );

}
