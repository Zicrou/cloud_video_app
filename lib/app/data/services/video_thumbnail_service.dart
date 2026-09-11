import 'dart:io';

import 'package:video_thumbnail/video_thumbnail.dart';

class VideoThumbnailService {
  Future<File?> generateThumbnail(String videoUrl) async {
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 400,
      quality: 75,
    );

    if (thumbnailPath == null) {
      return null;
    }

    return File(thumbnailPath);
  }
}