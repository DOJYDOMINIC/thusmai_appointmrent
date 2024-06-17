import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../constant/constant.dart';
import '../../controller/login_register_otp_api.dart';
import '../../controller/meditationController.dart';
import '../../controller/timer_controller.dart';
import '../../widgets/additionnalwidget.dart';
import 'meditationnote.dart';

AudioPlayer _audioPlayer = AudioPlayer();
const int alarmId = 0;

@pragma('vm:entry-point')
void startAlarmCallback() async {
  final String audioUrl = "https://firebasestorage.googleapis.com/v0/b/thasmai-star-life.appspot.com/o/general_images%2FY2meta.app%20-%20Shivashtakam%20Thasmai%20Namah%20Paramakarana%20written%20by%20Aadi%20Shankaracharya%20(320%20kbps).mp3?alt=media&token=845e902d-dccf-46fb-9a97-1013a6987c04";
  await _audioPlayer.setSourceUrl(audioUrl);
  await _audioPlayer.setReleaseMode(ReleaseMode.loop);
  await _audioPlayer.resume();
}

@pragma('vm:entry-point')
void stopAlarmCallback() async {
  await AndroidAlarmManager.cancel(alarmId);
  await _audioPlayer.stop();
}

class TimerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var timerProvider = Provider.of<TimerProvider>(context);
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
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                _buildHeader(appLogin, context),
                Spacer(),
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.grey.shade800,
                            Colors.black,
                          ],
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 130,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    CircularPercentIndicator(
                      backgroundColor: Colors.grey,
                      radius: 130.0,
                      lineWidth: 15.0,
                      percent: (timerProvider.initialSeconds - timerProvider.currentSeconds) / timerProvider.initialSeconds,
                      center: Text(
                        timerProvider.timerText,
                        style: TextStyle(fontSize: 40.0, color: Colors.white),
                      ),
                      progressColor: Colors.amber,
                    ),
                  ],
                ),
                Spacer(),
                if (timerProvider.currentSeconds > 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          timerProvider.resetTimer();
                        },
                        child: QuarterCircleContainer(
                          size: 170,
                          color: lightRed,
                          status: false,
                          child: buttonData("Cancel", Icons.backspace),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          timerProvider.isRunning ? timerProvider.pauseTimer() : timerProvider.resumeTimer();
                        },
                        child: QuarterCircleContainer(
                          size: 170,
                          color: goldShade,
                          status: true,
                          child: Center(
                            child: timerProvider.isRunning
                                ? buttonData("Pause", Icons.pause)
                                : buttonData("Start", Icons.smart_display),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (timerProvider.currentSeconds == 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ClipPath(
                      clipper: HalfCircleClipper(),
                      child: GestureDetector(
                        onTap: () {
                          String startTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(timerProvider.startDateTime!);
                          String endTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
                          meditation.meditationTime(startTime, endTime);
                          timerProvider.resetTimer();
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
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLogin appLogin, BuildContext context) {
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
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
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

  Widget buttonData(String text, IconData icon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(height: 10),
        Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ],
    );
  }
}
