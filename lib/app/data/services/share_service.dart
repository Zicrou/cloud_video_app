import 'package:share_plus/share_plus.dart';

class ShareService {
  
  Future<void> shareVideo({
 
    required int videoId,
  
    required String videoUrl,

    required String title,
 
  }) async {
 
    final message = '''
      Regarde cette vidéo 👇 $title
    
      $videoUrl
   
    ''';

    await SharePlus.instance.share(
      
      ShareParams(
      
        text: message,
      
      ),
   
    );

  }

}