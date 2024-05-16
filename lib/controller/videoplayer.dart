import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerState extends ChangeNotifier {

  bool _timeDelay = false;

  bool get timeDelay => _timeDelay;

  void changeValueAfterDelay() {
    Future.delayed(Duration(seconds: 1), () {
      _timeDelay = true;
      notifyListeners();
    });
  }

  late VideoPlayerController controller;
  double sliderValue = 0.0;

  VideoPlayerState() {
    controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    )..initialize().then((_) {
      controller.addListener(() {
        sliderValue = controller.value.position.inMilliseconds.toDouble();
        notifyListeners();
      });
      notifyListeners();
    });
  }

  void play() {
    controller.play();
  }

  void pause() {
    controller.pause();
  }

  void seekTo(double value) {
    controller.seekTo(Duration(milliseconds: value.toInt()));
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}