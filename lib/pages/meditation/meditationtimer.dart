import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
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

  bool isTimerRunning = false;
  bool isPaused = false;
  bool isCompleted = false;
  late DateTime startDateTime;
  late CountDownController _controller;
  late AudioPlayer _audioPlayer;

  final String audioUrl = "https://firebasestorage.googleapis.com/v0/b/thasmai-star-life.appspot.com/o/general_images%2FY2meta.app%20-%20Shivashtakam%20Thasmai%20Namah%20Paramakarana%20written%20by%20Aadi%20Shankaracharya%20(320%20kbps).mp3?alt=media&token=845e902d-dccf-46fb-9a97-1013a6987c04";

  @override
  void initState() {
    super.initState();
    _controller = CountDownController();
    _audioPlayer = AudioPlayer();
    Provider.of<AppLogin>(context, listen: false).getUserByID();
    AndroidAlarmManager.initialize();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startAlarm() async {
    await _audioPlayer.setSourceUrl(audioUrl);
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.resume();
  }

  void _stopAlarm() async {
    await _audioPlayer.stop();
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
          ),
        ),
        backgroundColor: darkShade,
        title: Text(
          "Meditate",
          style: TextStyle(color: shadeOne),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildHeader(appLogin),
              _buildTimer(),
              _buildControlButtons(),
              if (isCompleted) _buildCompletionBanner(meditation),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLogin appLogin) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 180.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            goldShade.withOpacity(.8),
            goldShade.withOpacity(.5),
            goldShade.withOpacity(.3),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.self_improvement, color: darkShade),
              SizedBox(width: 5),
              Text(
                "Start your meditation",
                style: TextStyle(color: darkShade, fontSize: 20.sp),
              ),
            ],
          ),
          SizedBox(height: 10),
          _buildUserDataRow("Cycle", appLogin.userData?.cycle ?? 0),
          _buildUserDataRow("Day", appLogin.userData?.day ?? 0),
        ],
      ),
    );
  }

  Widget _buildUserDataRow(String label, int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("$label "),
        Text(": $value"),
      ],
    );
  }

  Widget _buildTimer() {
    return CircularCountDownTimer(
      duration: 45*60,
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
      isReverse: true,
      isReverseAnimation: false,
      isTimerTextShown: true,
      autoStart: false,
      backgroundGradient: LinearGradient(
        colors: [Colors.black, Colors.black.withOpacity(.8), Colors.white],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      onStart: () {
        startDateTime = DateTime.now();
        print(DateFormat('yyyy-MM-dd HH:mm:ss').format(startDateTime));
      },
      onComplete: () {
        DateTime endDateTime = DateTime.now();
        Duration difference = endDateTime.difference(startDateTime);
        print('Timer completed');
        isCompleted = true;
        isTimerRunning = false;
        if (difference.inSeconds >= 3) {
          _startAlarm();
          WakelockPlus.disable();
        }
        setState(() {});
      },
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (!isCompleted) _buildCancelButton(),
        if (!isCompleted) _buildStartPauseResumeButton(),
      ],
    );
  }

  Widget _buildCancelButton() {
    return GestureDetector(
      onTap: () {
        if (!isCompleted) {
          _controller.reset();
          setState(() {
            isCompleted = false;
            isTimerRunning = false;
            isPaused = false;
          });
        }
      },
      child: QuarterCircleContainer(
        size: 170,
        color: lightRed,
        status: false,
        child: buttonData("Cancel", Icons.backspace),
      ),
    );
  }

  Widget _buildStartPauseResumeButton() {
    return GestureDetector(
      onTap: () {
        if (isCompleted) return;
        if (!isTimerRunning) {
          _controller.start();
          WakelockPlus.enable();
          setState(() {
            isTimerRunning = true;
            isPaused = false;
          });
        } else if (isPaused) {
          _controller.resume();
          setState(() {
            isPaused = false;
          });
        } else {
          _controller.pause();
          setState(() {
            isPaused = true;
          });
        }
      },
      child: QuarterCircleContainer(
        size: 170,
        color: goldShade,
        status: true,
        child: Center(
          child: !isTimerRunning
              ? buttonData("Start", Icons.smart_display)
              : isPaused
              ? buttonData("Resume", Icons.smart_display)
              : buttonData("Pause", Icons.pause),
        ),
      ),
    );
  }

  Widget _buildCompletionBanner(MeditationController meditation) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipPath(
        clipper: HalfCircleClipper(),
        child: GestureDetector(
          onTap: () {
            _stopAlarm();
            String startTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(startDateTime);
            String endTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
            meditation.meditationTime(startTime, endTime);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MeditationNote()),
            );
          },
          child: Container(
            color: greenColor,
            width: MediaQuery.of(context).size.width,
            height: 130,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Meditation \nCompleted",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
