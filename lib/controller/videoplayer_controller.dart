import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

import '../constant/constant.dart';
import '../models/playlist.dart';
import '../models/videoslist.dart';
class VideoPlayerStateController extends ChangeNotifier {

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

  VideoPlayerStateController() {
    controller = VideoPlayerController.networkUrl(
      Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
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

  // Future<void> videoPlaylist() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var cookies = prefs.getString("cookie");
  //   print(cookies);
  //   try {
  //     var response = await http.post(
  //       Uri.parse("$baseUrl/videos-by-playlist"),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         if (cookies != null) 'Cookie': cookies,
  //       },
  //       body:  jsonEncode({"playList_heading":"yoga"})
  //     );
  //     if (response.statusCode == 200) {
  //       final dataList = jsonDecode(response.body);
  //
  //     } else {
  //       print('Failed to load appointments: ${response.reasonPhrase}');
  //     }
  //   } catch (e) {
  //     print('Error fetching appointments: $e');
  //   }
  //   notifyListeners();
  // }


  PlayList _playList = PlayList();
  PlayList get playList => _playList;

  Future<void> playlistDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    print(cookies);
    try {
      var response = await http.get(
        Uri.parse("$baseUrl/playlists"),
        headers: {
          'Content-Type': 'application/json',
          if (cookies != null) 'Cookie': cookies,
        },
      );
      if (response.statusCode == 200) {
        final dataList = jsonDecode(response.body);
        _playList = PlayList.fromJson(dataList);
      } else {
        print('Failed to load appointments: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching appointments: $e');
    }
    notifyListeners();
  }

  VideoPlayList _videoPlayList = VideoPlayList();
  VideoPlayList get videoPlayList => _videoPlayList;

  Future<void> videoPlaylistDetails(String category ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    print(cookies);
    try {
      var response = await http.get(
        Uri.parse("$baseUrl/videos-by-playlist?playList_heading=$category"),
        headers: {
          'Content-Type': 'application/json',
          if (cookies != null) 'Cookie': cookies,
        },
      );
      if (response.statusCode == 200) {
        final dataList = jsonDecode(response.body);
        _videoPlayList    = VideoPlayList.fromJson(dataList);
      } else {
        print('Failed to load appointments: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching appointments: $e');
    }
    notifyListeners();
  }



}