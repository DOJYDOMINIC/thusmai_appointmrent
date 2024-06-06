// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:thusmai_appointmrent/constant/constant.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// // import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import '../../controller/login_register_otp_api.dart';
// import '../../controller/meditationController.dart';
// import '../../widgets/additionnalwidget.dart';
// import '../bottom_navbar.dart';
// import 'meditationtimer.dart';
//
// class Meditationcycle extends StatefulWidget {
//   const Meditationcycle({Key? key}) : super(key: key);
//
//   @override
//   State<Meditationcycle> createState() => _MeditationcycleState();
// }
//
// class _MeditationcycleState extends State<Meditationcycle> {
//   // double _progress = 0.0;
//   // bool _isPlaying = false;
//   bool isPressed = false;
//   late Color sun; // Added this line
//   late Color moon; // Added this line
//   Color ambercolor = Colors.amber;
//
//   @override
//   void initState() {
//     super.initState();
//     // _initializeVideoController();
//     Provider.of<AppLogin>(context, listen: false).getUserByID();
//     Provider.of<AppLogin>(context, listen: false).importantFlags();
//     var id = Provider.of<AppLogin>(context, listen: false).userData?.uId ?? "";
//     Provider.of<MeditationController>(context, listen: false)
//         .meditationTimeDetails(id);
//     // _controller.play();
//     // checkTime();
//   }
//
//   // void _initializeVideoController() {
//   //
//   //   sun = Colors.grey;
//   //   moon = Colors.grey;
//   //
//   //   String youtubeUrl = 'https://www.youtube.com/watch?v=VNSxTanl3YU';
//   //
//   //   List<String> parts = youtubeUrl.split('=');
//   //
//   //   String videoId = parts[1];
//   //
//   //   var time =  TimeOfDay.now();
//   //
//   //   // (((time.hour >= 6 && time.minute >= 30) && (time.hour <= 10 && time.minute >= 30)) || ((time.hour >= 6 && time.minute >= 30) && (time.hour <= 10 && time.minute >= 30)));
//   //   if (time.hour >= 6 && time.hour < 10) {
//   //     sun = ambercolor;
//   //     // Replace with your morning border color
//   //     videoId;
//   //     // Replace with your morning video ID
//   //   } else if (time.hour >= 11 && time.hour < 22) {
//   //     moon = ambercolor;
//   //     // Replace with your afternoon border color
//   //     videoId;
//   //     // Replace with your evening video ID
//   //   } else {
//   //     // Default video ID for other times
//   //     videoId; // Replace with your default video ID
//   //   }
//   // }
//
//   @override
//   void dispose() {
//     // _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var time = Provider.of<MeditationController>(context).meditationTimeData;
//
//     var flagModel = Provider.of<AppLogin>(context).flagModel;
//     var pro = Provider.of<AppLogin>(context);
//
//     String getYoutubeThumbnail(String videoLink) {
//       final uri = Uri.parse(time.video.toString());
//       final videoId =
//           uri.queryParameters['v']?.trim() ?? uri.pathSegments.last.trim();
//       return 'https://img.youtube.com/vi/$videoId/0.jpg';
//     }
//
//     // var height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor: shadeOne,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.only(right: 20, left: 20),
//           child: SingleChildScrollView(
//             child: Container(
//               height: MediaQuery.of(context).size.height - 250.h,
//               child: Column(
//                 children: [
//                   spaceBetween,
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       meditationCycleWidget(
//                           "Meditation Cycle",
//                           "${pro.userData?.day ?? 0}",
//                           "${pro.userData?.cycle ?? 0}",
//                           "${pro.userData?.cycle ?? 0}"),
//                       Container(
//                         width: 2,
//                         height: 208,
//                         color: shadeEight,
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Row(
//                             children: [
//                               timeSetup("Morning", "05:00 AM", "7:30 AM"),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Container(
//                                   width: 90.w,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(8),
//                                     gradient: LinearGradient(
//                                       colors: [
//                                         Colors.grey.shade900,
//                                         Colors.black
//                                       ],
//                                       begin: Alignment.topCenter,
//                                       end: Alignment.bottomCenter,
//                                     ),
//                                     color: Colors.black,
//                                     border: Border.all(
//                                         width: 4.w,
//                                         color: sun), // Updated this line
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(15),
//                                     child: Image(
//                                         fit: BoxFit.fill,
//                                         image: AssetImage(
//                                             "assets/images/sun.png")),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 8,
//                           ),
//                           Container(
//                             width: 176.w,
//                             height: 1.h,
//                             color: shadeEight,
//                           ),
//                           SizedBox(
//                             height: 8.h,
//                           ),
//                           Row(
//                             children: [
//                               timeSetup("Evening", "06:30 PM", "10:30 PM"),
//                               Padding(
//                                 padding: const EdgeInsets.all(8),
//                                 child: Container(
//                                   width: 90.w,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(8),
//                                     gradient: LinearGradient(
//                                       colors: [
//                                         Colors.grey.shade900,
//                                         Colors.black
//                                       ],
//                                       begin: Alignment.topCenter,
//                                       end: Alignment.bottomCenter,
//                                     ),
//                                     border: Border.all(
//                                         width: 4,
//                                         color: moon), // Updated this line
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(15),
//                                     child: Image(
//                                         fit: BoxFit.fill,
//                                         image: AssetImage(
//                                             "assets/images/moon.png")),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   spaceBetween,
//                   GestureDetector(
//                     onTap: () {
//                       launchUrl(Uri.parse(
//                           "https://www.youtube.com/watch?v=VNSxTanl3YU"));
//                     },
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(15.0),
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           Container(
//                             height: 210.h,
//                             width: MediaQuery.of(context).size.width,
//                             decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                     fit: BoxFit.cover,
//                                     image: NetworkImage(getYoutubeThumbnail(
//                                         "https://www.youtube.com/watch?v=VNSxTanl3YU")))),
//                           ),
//                           Icon(
//                             Icons.play_arrow,
//                             size: 50.0,
//                             color: Colors.white,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Spacer(),
//                   SizedBox(
//                     height: 56.h,
//                     width: 304.w,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         if (flagModel.meditationFeePaymentStatus == true) {
//                           var now = TimeOfDay.now();
//                           if (((now.hour >= 6) && (now.hour <= 10)) ||
//                               ((now.hour >= 11) && (now.hour <= 22))) {
//                             slidePageRoute(context, TimerScreen());
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text(
//                                     "Sorry,Your are not able to Meditate now"),
//                                 backgroundColor: Colors.red,
//                               ),
//                             );
//                           }
//                         } else {
//                           pro.currentIndex = 3;
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               backgroundColor: Colors.red,
//                               content: Text(enable),
//                               duration: Duration(seconds: 2),
//                             ),
//                           );
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         shadowColor: Colors.black,
//                         backgroundColor:
//                             flagModel.meditationFeePaymentStatus == false
//                                 ? Colors.grey
//                                 : goldShade,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(100),
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "Start Meditation",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Spacer(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   launchURL(Uri url) async {
//     if (!await launchUrl(url)) {
//       throw Exception('Could not launch url');
//     }
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/login_register_otp_api.dart';
import '../../controller/meditationController.dart';
import '../../models/meditationfulltime.dart';
import '../../widgets/additionnalwidget.dart';
import 'meditationtimer.dart';

class MeditationCycle extends StatefulWidget {
  const MeditationCycle({Key? key}) : super(key: key);

  @override
  State<MeditationCycle> createState() => _MeditationCycleState();
}

class _MeditationCycleState extends State<MeditationCycle> {
  bool isPressed = false;
  Color amberColor = Colors.amber;
  Timer? _timer;
  MeditationTimeDetails? meditationFullTime;
  @override
  void initState() {
    super.initState();
    Provider.of<AppLogin>(context, listen: false).getUserByID();
    Provider.of<AppLogin>(context, listen: false).importantFlags();
    Provider.of<MeditationController>(context, listen: false).meditationTimeDetails(context);
    Provider.of<MeditationController>(context, listen: false).meditationDetailsTime();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      // Timer functionality
    });
  }

  void onTimeMatch() {
    // Your code for time match
    create();
  }

  void create() {
    // Add your creation logic here
  }

  String convertToAmPm(String time) {
    List<String> timeParts = time.split(":");
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    String period = hour >= 12 ? "PM" : "AM";
    hour = hour % 12;
    hour = hour == 0 ? 12 : hour;
    String minuteString = minute.toString().padLeft(2, '0');
    return "$hour:$minuteString $period";
  }

  String getYoutubeThumbnail(String url) {
    final uri = Uri.parse(url);
    final videoId = uri.queryParameters['v']?.trim() ?? uri.pathSegments.last.trim();
    return 'https://img.youtube.com/vi/$videoId/0.jpg';
  }

  bool isCurrentTimeBetween(String fromTime, String toTime) {
    TimeOfDay from = TimeOfDay(
      hour: int.parse(fromTime.split(":")[0]),
      minute: int.parse(fromTime.split(":")[1]),
    );
    TimeOfDay to = TimeOfDay(
      hour: int.parse(toTime.split(":")[0]),
      minute: int.parse(toTime.split(":")[1]),
    );
    TimeOfDay now = TimeOfDay.now();
    if (from.hour < to.hour || (from.hour == to.hour && from.minute <= to.minute)) {
      return (now.hour > from.hour || (now.hour == from.hour && now.minute >= from.minute)) &&
          (now.hour < to.hour || (now.hour == to.hour && now.minute <= to.minute));
    } else {
      return (now.hour > from.hour || (now.hour == from.hour && now.minute >= from.minute)) ||
          (now.hour < to.hour || (now.hour == to.hour && now.minute <= to.minute));
    }
  }

  @override
  Widget build(BuildContext context) {
    var timeManage = Provider.of<MeditationController>(context).meditationTimeData;
    var meditationFullTime = Provider.of<MeditationController>(context).meditationFullTime;
    var flagModel = Provider.of<AppLogin>(context).flagModel;
    var pro = Provider.of<AppLogin>(context);

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
                              timeSetup("Morning", "${convertToAmPm(meditationFullTime.morningTimeFrom.toString())}", "${convertToAmPm(meditationFullTime.morningTimeTo.toString())}"),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 90.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: LinearGradient(
                                      colors: [Colors.grey.shade900, Colors.black],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    color: Colors.black,
                                    border: Border.all(width: 4.w, color: isCurrentTimeBetween(meditationFullTime.morningTimeFrom.toString(), meditationFullTime.morningTimeTo.toString()) == true ? amberColor : Colors.grey),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Image(
                                      fit: BoxFit.fill,
                                      image: AssetImage("assets/images/sun.png"),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: 176.w,
                            height: 1.h,
                            color: shadeEight,
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              timeSetup("Evening", "${convertToAmPm(meditationFullTime.eveningTimeFrom.toString())}", "${convertToAmPm(meditationFullTime.eveningTimeTo.toString())}"),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Container(
                                  width: 90.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: LinearGradient(
                                      colors: [Colors.grey.shade900, Colors.black],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    border: Border.all(width: 4, color: isCurrentTimeBetween(meditationFullTime.eveningTimeFrom.toString(), meditationFullTime.eveningTimeTo.toString())  == true? amberColor : Colors.grey),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Image(
                                      fit: BoxFit.fill,
                                      image: AssetImage("assets/images/moon.png"),
                                    ),
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
                      launchURL(Uri.parse(timeManage.video.toString()));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 210.h,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  getYoutubeThumbnail(timeManage.video.toString()),
                                ),
                              ),
                            ),
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
                  Spacer(),
                  SizedBox(
                    height: 56.h,
                    width: 304.w,
                    child: ElevatedButton(
                      onPressed: () {
                        if (flagModel.meditationFeePaymentStatus == true) {
                          if (isCurrentTimeBetween(timeManage.fromTime.toString(), timeManage.toTime.toString())) {
                            slidePageRoute(context, TimerScreen());
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Sorry, you are not able to meditate now"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } else {
                          pro.currentIndex = 3;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(enable),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.black,
                        backgroundColor: flagModel.meditationFeePaymentStatus == true ? goldShade : Colors.grey,
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

  Future<void> launchURL(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch URL');
    }
  }
}
