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

  final Map<String, dynamic>? video;

  VideoUploadController({
    this.video,
  });

  @override
  void onInit() {
    super.onInit();

    if (video != null) {
      title.value = video!['title']?.toString() ?? '';
    }
  }

  Future<void> pickVideo() async {
    final pickedFile = await _picker.pickVideo(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      selectedVideo.value = File(pickedFile.path);
    }
  }

  Future<void> uploadVideo() async {
    final editingVideo = video;

    if (editingVideo == null && selectedVideo.value == null) {
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

      if (editingVideo == null) {
        // Création
        final result = await _uploadService.uploadVideo(
          title: title.value.trim(),
          videoFile: selectedVideo.value!,
          onProgress: (sent, total) {
            if (total > 0) {
              uploadProgress.value = sent / total;
            }
          },
        );

        logger.d(result);
      } else {
        // Modification
        final videoId = editingVideo['id'];

        final result = await _uploadService.updateVideo(
          videoId: videoId as int,
          title: title.value.trim(),
          videoFile: selectedVideo.value,
          onProgress: (sent, total) {
            if (total > 0) {
              uploadProgress.value = sent / total;
            }
          },
        );

        logger.d(result);
      }
      logger.d('Current route: ${Get.currentRoute}');
      logger.d('Previous route: ${Get.previousRoute}');
      logger.d(
        'Can pop: ${Navigator.of(Get.context!).canPop()}',
      );  

      Get.snackbar(
        'Succès',
        editingVideo == null
            ? 'Vidéo publiée avec succès.'
            : 'Vidéo modifiée avec succès.',
      );

      Navigator.of(Get.context!).pop(true);
    } catch (error, stackTrace) {
      logger.e(
        'Video operation error',
        error: error,
        stackTrace: stackTrace,
      );

      Get.snackbar(
        'Erreur',
        editingVideo == null
            ? 'Échec de la publication de la vidéo.'
            : 'Échec de la modification de la vidéo.',
      );
    } finally {
      isUploading.value = false;
    }
  }
}