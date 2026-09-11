import 'dart:io';

import 'package:cloud_video_app/app/data/services/video_upload_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

final logger = Logger();
class VideoUploadController extends GetxController {
  final VideoUploadService _uploadService =
      Get.find<VideoUploadService>();

  final selectedVideo = Rxn<File>();
  final title = ''.obs;

  final isUploading = false.obs;
  final uploadProgress = 0.0.obs;

  final ImagePicker _picker = ImagePicker();


  Future<void> pickVideo() async {
    final pickedFile = await _picker.pickVideo(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      selectedVideo.value = File(pickedFile.path);
    }
  }

  Future<void> uploadVideo() async {
    final video = selectedVideo.value;

    if (video == null) {
      Get.snackbar(
        'Erreur',
        'Veuillez sélectionner une vidéo.',
      );
      return;
    }

    if (title.value.trim().isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez saisir un titre.',
      );
      return;
    }

    try {
      isUploading.value = true;
      uploadProgress.value = 0;

      final result = await _uploadService.uploadVideo(
      title: title.value.trim(),
      videoFile: video,
      onProgress: (sent, total) {
        if (total > 0) {
          uploadProgress.value = sent / total;
        }
      },
    );

    Get.snackbar(
      'Succès',
      'Vidéo publiée avec succès.',
    );

    logger.d(result);

    logger.d('AVANT retour');
    logger.d('Route actuelle : ${Get.currentRoute}');
    logger.d('Route précédente : ${Get.previousRoute}');
    logger.d('Can pop navigator: ${Navigator.of(Get.context!).canPop()}');

    Navigator.of(Get.context!).pop(true);

    logger.d('APRÈS retour');
    } catch (e, s) {
      logger.e(
        'Upload error',
        error: e,
        stackTrace: s,
      );

      Get.snackbar(
        'Erreur',
        'Échec de l upload de la vidéo.',
      );
    } finally {
      isUploading.value = false;
    }
  }
}