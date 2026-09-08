import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

final logger = Logger();
class DeepLinkService extends GetxService {
  final AppLinks _appLinks = AppLinks();

  StreamSubscription<Uri>? _subscription;

  Future<void> init() async {
    // App lancée par un deep link
    final initialUri = await _appLinks.getInitialLink();

    if (initialUri != null) {
      
      _handleUri(initialUri);
   
    }

    // App déjà ouverte puis réception d'un deep link
    _subscription = _appLinks.uriLinkStream.listen(
      _handleUri,
      onError: (error) {
        logger.e('Deep link error: $error');
      },
    );
  }

  void _handleUri(Uri uri) {
    logger.i('DEEP LINK: $uri');
    logger.i('HOST: ${uri.host}');
    logger.i('PATH: ${uri.path}');
    logger.i('SEGMENTS: ${uri.pathSegments}');

    if (uri.scheme == 'cloudvideo' &&
        uri.host == 'videos' &&
        uri.pathSegments.isNotEmpty) {
      
      final videoId = int.tryParse(uri.pathSegments.first);

      if (videoId != null) {
        logger.i('VIDEO ID: $videoId');
        _openVideo(videoId);
      }
    }
  }

  void _openVideo(int videoId) {
    
    logger.i('Opening video: $videoId');

    // Navigation à ajouter

  }

  @override
  void onClose() {
   
    _subscription?.cancel();
   
    super.onClose();
  
  }
}