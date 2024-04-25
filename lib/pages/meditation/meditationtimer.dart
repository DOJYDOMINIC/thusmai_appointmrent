import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../constant/constant.dart';
import '../../controller/login_register_otp_api.dart';
import '../../controller/meditationController.dart';
import '../../widgets/additionnalwidget.dart';
import 'meditationnote.dart';

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  bool isTimerRunning = false; // Flag to track if the timer is running
  bool isPaused = false; // Flag to track if the timer is running
  bool isCompleted = false;
  String startTime = "";
  String endTime = "";

  late CountDownController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CountDownController();
    Provider.of<AppLogin>(context, listen: false).getUserByID();
  }

  @override
  Widget build(BuildContext context) {
    var appLogin = Provider.of<AppLogin>(context);
    var meditation = Provider.of<MeditationController>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: shadeOne,
            )),
        backgroundColor: darkShade,
        title: Text(
          "Meditate",
          style: TextStyle(color: shadeOne),
        ),
        // centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 180.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      goldShade.withOpacity(.8), // Lighter color
                      goldShade.withOpacity(.5), // Lighter color
                      goldShade.withOpacity(.3), // Lighter color
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.self_improvement,
                          color: darkShade,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Start your meditation",
                          style: TextStyle(
                            color: darkShade,
                            fontSize: 20.sp,
                          ),
                        ),
                      ],
                    ),
                    spaceBetween,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("cycle"),
                        Text("   : ${appLogin.userData?.cycle ?? 0}"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Day  "),
                        Text("    : ${appLogin.userData?.day ?? 0}"),
                      ],
                    ),
                  ],
                ),
              ),
              CircularCountDownTimer(
                duration: 3,
                // 45 * 60,
                initialDuration: 0,
                controller: _controller,
                width: 320.w,
                height: 320.h,
                ringColor: ringColor,
                fillColor: Colors.amber,
                backgroundColor: Colors.black,
                strokeWidth: 15.0,
                strokeCap: StrokeCap.round,
                textStyle: TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textFormat: CountdownTextFormat.MM_SS,
                isReverse: false,
                isReverseAnimation: false,
                isTimerTextShown: true,
                autoStart: false,
                backgroundGradient: LinearGradient(colors: [
                  Colors.black,
                  Colors.black.withOpacity(.8),
                  Colors.white
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                onStart: () {
                  DateTime now = DateTime.now();
                  startTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                  print(startTime);
                },
                onComplete: () {
                  DateTime now = DateTime.now();
                  endTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
                  // Timer completed
                  print('Timer completed');
                  isCompleted = true;
                  isTimerRunning = true;
                  setState(() {});
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!isCompleted)
                    GestureDetector(
                      onTap: () {
                        if (!isCompleted) {
                          isPaused = false;
                          _controller.reset();
                          setState(() {
                            isCompleted = false; // Reset the completion status
                            isTimerRunning = false; // Reset the running status
                          });
                        }
                      },
                      child: QuarterCircleContainer(
                          size: 170,
                          color: lightRed,
                          status: false,
                          child: buttonData("Cancel", Icons.backspace)),
                    ),
                  if (!isCompleted)
                    GestureDetector(
                      onTap: () {
                        if (isCompleted) {
                        } else if (!isTimerRunning) {
                          _controller.start();
                          setState(() {
                            isTimerRunning = true;
                          });
                        } else if (isTimerRunning) {
                          if (!isPaused) {
                            isPaused = true;
                            _controller.pause();
                            setState(() {});
                          } else {
                            _controller.resume();
                            setState(() {
                              isPaused = false;
                            });
                          }
                        }
                      },
                      child: QuarterCircleContainer(
                        size: 170,
                        color: goldShade,
                        status: true,
                        child: Center(
                            child: !isTimerRunning
                                ? buttonData("Start", Icons.smart_display)
                                : !isPaused
                                    ? buttonData("Pause", Icons.pause)
                                    : buttonData(
                                        "Resume", Icons.smart_display)),
                      ),
                    ),
                ],
              ),
              if (isCompleted)
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20),
                  child: ClipPath(
                      clipper: HalfCircleClipper(),
                      child: GestureDetector(
                        onTap: (){
                          meditation.meditationTime(startTime,endTime );
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>MeditationNote(),));
                        },
                        child: Container(
                          color: greenColor,
                          width: MediaQuery.of(context).size.width,
                          height: 130,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Meditation \nCompleted"
                            ),
                          ),
                        ),
                      )
                      ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
