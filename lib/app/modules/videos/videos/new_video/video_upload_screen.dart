import 'package:cloud_video_app/app/modules/videos/videos/video_upload_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class VideoUploadScreen extends StatelessWidget {
  VideoUploadScreen({super.key});

  final VideoUploadController controller = Get.put(
    VideoUploadController(),
  );

  final TextEditingController titleController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publier une vidéo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Titre',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                controller.title.value = value;
              },
            ),

            const SizedBox(height: 20),

            Obx(
              () => OutlinedButton.icon(
                onPressed: controller.isUploading.value
                    ? null
                    : controller.pickVideo,
                icon: const Icon(Icons.video_library),
                label: Text(
                  controller.selectedVideo.value == null
                      ? 'Choisir une vidéo'
                      : 'Changer la vidéo',
                ),
              ),
            ),

            const SizedBox(height: 12),

            Obx(
              () {
                final video =
                    controller.selectedVideo.value;

                if (video == null) {
                  return const Text(
                    'Aucune vidéo sélectionnée',
                    textAlign: TextAlign.center,
                  );
                }

                return Text(
                  video.path.split('/').last,
                  textAlign: TextAlign.center,
                );
              },
            ),

            const SizedBox(height: 24),

            Obx(
              () {
                if (!controller.isUploading.value) {
                  return const SizedBox.shrink();
                }

                final progress =
                    controller.uploadProgress.value;

                return Column(
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(progress * 100).toStringAsFixed(0)} %',
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            Obx(
              () => ElevatedButton.icon(
                onPressed: controller.isUploading.value
                    ? null
                    : controller.uploadVideo,
                icon: const Icon(Icons.cloud_upload),
                label: const Text('Publier'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}