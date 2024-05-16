import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';
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
  bool isPressed = false;
  late Color sun; // Added this line
  late Color moon; // Added this line
 Color ambercolor = Colors.amber;
  @override
  void initState() {
    super.initState();
    _initializeVideoController();
    Provider.of<AppLogin>(context, listen: false).getUserByID();

  }

  late YoutubePlayerController _controller;
  void _initializeVideoController() {
    DateTime now = DateTime.now();

    String videoId;
    sun = Colors.grey;
    moon = Colors.grey;

    // Check if it's morning (6:00 AM to 9:00 AM)
    if (now.hour >= 6 && now.hour < 10) {
      sun = ambercolor; // Replace with your morning border color
      videoId = 'aH96tw8fXfk'; // Replace with your morning video ID
    } else if (now.hour >= 18 && now.hour < 22) {
      // Check if it's evening (6:30 PM to 10:00 PM)
      moon = ambercolor; // Replace with your afternoon border color
      videoId = 'kvRq5sJsuHY'; // Replace with your evening video ID
    } else {
      // Default video ID for other times
      videoId = '60ItHLz5WEA'; // Replace with your default video ID
    }

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false, // Don't set loop to true to handle replay manually
        isLive: false,
        forceHD: false,
        enableCaption: false,

      ),
    );

  //   _controller.addListener(() {
  //     if (_controller.value.playerState == PlayerState.ended) {
  //       // Video has ended, seek to the beginning to replay
  //       _controller.seekTo(const Duration(microseconds: 1000));
  //       _controller.pause(); // Optionally, you can auto-play after seeking to the beginning
  //     }
  //   });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  var pro =  Provider.of<AppLogin>(context);
    // var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: shadeOne,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height- 250.h,
              child: Column(
                children: [
                  spaceBetween,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      meditationCycleWidget("Meditation Cycle","${pro.userData?.day??0}","${pro.userData?.cycle??0}","${pro.userData?.cycle??0}"),
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
                                      colors: [Colors.grey.shade900, Colors.black],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    color: Colors.black,
                                    border: Border.all(
                                        width: 4.w, color: sun), // Updated this line
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Image(
                                        fit: BoxFit.fill,
                                        image: AssetImage("assets/images/sun.png")),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8,),
                          Container(
                            width: 176.w,
                            height: 1.h,
                            color: shadeEight,
                          ),
                          SizedBox(height: 8.h,),
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
                                      colors: [Colors.grey.shade900, Colors.black],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    border: Border.all(
                                        width: 4, color: moon), // Updated this line
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Image(
                                        fit: BoxFit.fill,
                                        image: AssetImage("assets/images/moon.png")),
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0), // Adjust the radius as needed
                    child: YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Colors.blueAccent,
                      progressColors: ProgressBarColors(
                        playedColor: Colors.amber,
                        handleColor: Colors.amberAccent,
                      ),
                      onReady: () {
                        // You can perform actions when the player is ready.
                        print("ready");
                      },
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    height: 56.h,
                    width: 304.w,
                    child: ElevatedButton(
                      onPressed: () {
                        DateTime now = DateTime.now();
                        print(now.hour+now.minute);

                        // Check the time conditions to determine whether to navigate or not
                        if ((now.hour+now.minute  >= 6 && now.hour < 18) ||
                            (now.hour >= 18 && now.hour < 22)) {
                          _controller.pause();
                          slidePageRoute(context,TimerScreen());
                          // Navigator.push(context,MaterialPageRoute(builder: (context) => TimerScreen(),));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Button is disabled at this time.'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.black, backgroundColor: goldShade,
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
}





