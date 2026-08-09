import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cloud_video_app/app/core/values/app_colors.dart';

void noInternetSnack() {
  Get.snackbar(
    'Pas de connection internet',
    'Vérifier que vous êtes bien connecter à un réseau.',
    icon: Icon(
      Icons.signal_wifi_connected_no_internet_4,
      color: AppColors.primaryColor,
    ),
  );
}
