import 'package:get/get.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoPlayerControllerGetx extends GetxController {
  late YoutubePlayerController ytController;
  final String videoId = Get.arguments['videoId'] ?? '';
  final String title = Get.arguments['title'] ?? 'Video';
  final String desc = Get.arguments['desc'] ?? '';

  @override
  void onInit() {
    super.onInit();
    ytController = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );
  }

  @override
  void onClose() {
    ytController.close();
    super.onClose();
  }
}
