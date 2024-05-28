import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../controller/login_register_otp_api.dart';
import '../../controller/meditationController.dart';
import '../../widgets/additionnalwidget.dart';
import 'meditationtimer.dart';

class Meditationcycle extends StatefulWidget {
  const Meditationcycle({Key? key}) : super(key: key);

  @override
  State<Meditationcycle> createState() => _MeditationcycleState();
}

class _MeditationcycleState extends State<Meditationcycle> {
  // double _progress = 0.0;
  // bool _isPlaying = false;
  bool isPressed = false;
  late Color sun; // Added this line
  late Color moon; // Added this line
  Color ambercolor = Colors.amber;

  @override
  void initState() {
    super.initState();
    _initializeVideoController();
    Provider.of<AppLogin>(context, listen: false).getUserByID();
    Provider.of<MeditationController>(context, listen: false)
        .meditationTimeDetails();
    // _controller.play();
    // checkTime();
  }

  // bool buttonStatus = false;
  //
  // String result = '';
  //
  // void checkTime() {
  //   // Get the current time
  //   DateTime now = DateTime.now();
  //   TimeOfDay currentTime = TimeOfDay.fromDateTime(now);
  //   print(currentTime.toString());
  //   // Define the start and end times
  //   TimeOfDay startTime = TimeOfDay(hour: 13, minute: 0); // 14:00 (2:00 PM)
  //   TimeOfDay endTime = TimeOfDay(hour: 18, minute: 0); // 18:00 (6:00 PM)
  //
  //   // Check if the current time is between the start and end times
  //   if (isTimeBetween(currentTime, startTime, endTime)) {
  //     setState(() {
  //       buttonStatus = true;
  //     });
  //     // slidePageRoute(context, TimerScreen());
  //   } else {
  //     setState(() {
  //       buttonStatus = false;
  //     });
  //   }
  // }
  //
  // bool isTimeBetween(
  //     TimeOfDay currentTime, TimeOfDay startTime, TimeOfDay endTime) {
  //   final now = DateTime.now();
  //   final currentDateTime = DateTime(
  //       now.year, now.month, now.day, currentTime.hour, currentTime.minute);
  //   final startDateTime = DateTime(
  //       now.year, now.month, now.day, startTime.hour, startTime.minute);
  //   final endDateTime =
  //       DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);
  //
  //   return currentDateTime.isAfter(startDateTime) &&
  //       currentDateTime.isBefore(endDateTime);
  // }

  // String _printDuration(Duration duration) {
  //   String twoDigits(int n) => n.toString().padLeft(2, "0");
  //   String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  //   String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  //   return "${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds";
  // }

  // late YoutubePlayerController _controller;

  late PlayerState _playerState;

  void _initializeVideoController() {
    DateTime now = DateTime.now();

    sun = Colors.grey;
    moon = Colors.grey;

    String youtubeUrl = 'https://www.youtube.com/watch?v=VNSxTanl3YU';
    List<String> parts = youtubeUrl.split('=');
    String videoId = parts[1];
    (((now.hour >= 6 && now.minute >= 30) && (now.hour <= 10 && now.minute >= 30)) ||
        ((now.hour >= 6 && now.minute >= 30) &&(now.hour <= 10 && now.minute >= 30)));
    if (now.hour >= 6 && now.hour < 10) {
      sun = ambercolor;
      // Replace with your morning border color
      videoId;
      // Replace with your morning video ID
    } else if (now.hour >= 18 && now.hour < 22) {
      sun = ambercolor;
      // Replace with your afternoon border color
      videoId;
      // Replace with your evening video ID
    } else {
      // Default video ID for other times
      videoId; // Replace with your default video ID
    }

    // _controller = YoutubePlayerController(
    //   initialVideoId: videoId,
    //   flags: YoutubePlayerFlags(
    //       mute: false,
    //       autoPlay: false,
    //       disableDragSeek: false,
    //       loop: false,
    //       // Don't set loop to true to handle replay manually
    //       isLive: false,
    //       forceHD: false,
    //       enableCaption: false,
    //       hideControls: true),
    // );
  }

  //   _controller.addListener(() {
  //     if (_controller.value.playerState == PlayerState.ended) {
  //       // Video has ended, seek to the beginning to replay
  //       _controller.seekTo(const Duration(microseconds: 1000));
  //       _controller.pause(); // Optionally, you can auto-play after seeking to the beginning
  //     }
  //   });

  // void listener() {
  //   if (_controller.value.playerState != _playerState) {
  //     setState(() {
  //       _playerState = _controller.value.playerState;
  //     });
  //   }
  //   setState(() {
  //   _progress = _controller.value.position.inSeconds.toDouble();
  //   });
  // }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<AppLogin>(context);
    String getYoutubeThumbnail(String videoLink) {
      final uri = Uri.parse(videoLink);
      final videoId = uri.queryParameters['v']?.trim() ??
          uri.pathSegments.last.trim();
      return 'https://img.youtube.com/vi/$videoId/0.jpg';
    }
    // var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: shadeOne,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height - 250.h,
              child: Column(
                children: [
                  spaceBetween,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      meditationCycleWidget(
                          "Meditation Cycle",
                          "${pro.userData?.day ?? 0}",
                          "${pro.userData?.cycle ?? 0}",
                          "${pro.userData?.cycle ?? 0}"),
                      Container(
                        width: 2,
                        height: 208,
                        color: shadeEight,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              timeSetup("Morning", "05:30 AM", "7:30 AM"),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 90.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.grey.shade900,
                                        Colors.black
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    color: Colors.black,
                                    border: Border.all(
                                        width: 4.w,
                                        color: sun), // Updated this line
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Image(
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                            "assets/images/sun.png")),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            width: 176.w,
                            height: 1.h,
                            color: shadeEight,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Row(
                            children: [
                              timeSetup("Evening", "09:30 PM", "10:30 PM"),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Container(
                                  width: 90.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.grey.shade900,
                                        Colors.black
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    border: Border.all(
                                        width: 4,
                                        color: moon), // Updated this line
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Image(
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                            "assets/images/moon.png")),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  spaceBetween,
                  GestureDetector(
                    onTap: () {
                      launchUrl(Uri.parse("https://www.youtube.com/watch?v=VNSxTanl3YU"));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 210.h,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(image:DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(getYoutubeThumbnail("https://www.youtube.com/watch?v=VNSxTanl3YU")))),
                          ),
                          Icon(
                            Icons.play_arrow,
                            size: 50.0,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     Text(
                  //       "${_printDuration(Duration(seconds: _progress.toInt()))}",
                  //     ),
                  //     IconButton(
                  //       onPressed: () {
                  //         setState(() {
                  //           if (!_isPlaying) {
                  //             _controller.play();
                  //           } else {
                  //             _controller.pause();
                  //           }
                  //           _isPlaying =
                  //           !_isPlaying; // Toggle the play/pause state
                  //         });
                  //       },
                  //       icon: Icon(
                  //         _isPlaying ? Icons.pause : Icons.play_arrow,
                  //         // Change icon to pause if playing, otherwise play_arrow
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Slider(
                  //         activeColor: goldShade,
                  //         value: _progress,
                  //         min: 0.0,
                  //         max: _controller.metadata.duration.inSeconds.toDouble(),
                  //         onChanged: (value) {
                  //           setState(() {
                  //             _progress = value;
                  //           });
                  //         },
                  //         onChangeEnd: (value) {
                  //           _controller
                  //               .seekTo(Duration(seconds: value.toInt()));
                  //         },
                  //       ),
                  //     ),
                  //     Text(
                  //       "${_printDuration(_controller.metadata.duration)}",
                  //     ),
                  //   ],
                  // ),
                  Spacer(),
                  SizedBox(
                    height: 56.h,
                    width: 304.w,
                    child: ElevatedButton(
                      onPressed: () {
                        DateTime now = DateTime.now();
                        if (((now.hour >= 6 && now.minute >= 30) && (now.hour <= 10 && now.minute >= 30)) ||
                            ((now.hour >= 6 && now.minute >= 30) &&(now.hour <= 10 && now.minute >= 30))) {
                          // _controller.pause();
                          slidePageRoute(context, TimerScreen());
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Sorry,Your are not able to Meditate now"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.black,
                        backgroundColor: goldShade,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Start Meditation",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  launchURL(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch url');
    }
  }
}
