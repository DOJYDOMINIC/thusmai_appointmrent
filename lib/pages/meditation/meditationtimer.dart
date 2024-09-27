import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../constant/constant.dart';
import '../../controller/connectivitycontroller.dart';
import '../../controller/disable_meditation.dart';
import '../../controller/login_register_otp_api.dart';
import '../../controller/meditationController.dart';
import '../../controller/timer_controller.dart';
import '../../models/hive/meditationdata.dart';
import '../../widgets/additionnalwidget.dart';
import '../../widgets/popup_widget.dart';
import 'meditationnote.dart';

class TimerScreen extends StatefulWidget {
  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late TimerProvider timerProvider;
  late AppLogin appLogin;
  late MeditationController meditation;

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _showCancelDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 350.h,
            child: PopupWidget(
              heading: 'Cancel Timer',
              subHeading: 'Are you sure you want to cancel?',
              amount: '',
              buttonOneText: 'Yes',
              buttonTwoText: 'No',
              icon: Icons.timer,
              buttonColorOne: goldShade,
              buttonColorTwo: shadeOne,
              onPressOne: () {
                timerProvider.resetTimer();
                Navigator.of(context).pop(true); // Close the dialog
              },
              onPressTwo: () {
                Navigator.of(context).pop(false);
              },
            ),
          ),
        );
      },
    );

    // showDialog(
    //       context: context,
    //       builder: (BuildContext context) {
    //         return AlertDialog(
    //           title: Text("Cancel Timer"),
    //           content: Text("Are you sure you want to cancel?"),
    //           actions: [
    //             TextButton(
    //               onPressed: () {
    //                 Navigator.of(context).pop(false); // Close the dialog
    //               },
    //               child: Text("No"),
    //             ),
    //             TextButton(
    //               onPressed: () {
    //                 timerProvider.resetTimer();
    //                 Navigator.of(context).pop(true); // Close the dialog
    //               },
    //               child: Text("Yes"),
    //             ),
    //           ],
    //         );
    //   },
    // ) ??
    // false;
  }

  @override
  Widget build(BuildContext context) {
    final buttonStateNotifier = Provider.of<ButtonStateNotifier>(context);
    // final meditationFullTime = meditationController.meditationFullTime;
    timerProvider = Provider.of<TimerProvider>(context);
    appLogin = Provider.of<AppLogin>(context);
    meditation = Provider.of<MeditationController>(context);
    // var connect = Provider.of<ConnectivityProvider>(context);
    var box = Hive.box<MeditationData>('MeditationDataBox');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            bool shouldLeave = await _showCancelDialog(context);
            if (shouldLeave) {
              Navigator.of(context).pop(true); // Close the dialog
            }
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
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) {
            return;
          }
          final navigator = Navigator.of(context);
          bool value = await _showCancelDialog(context);
          if (value) {
            navigator.pop();
          }
        },
        child: SafeArea(
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
                        percent: (timerProvider.initialSeconds -
                                    timerProvider.currentSeconds)
                                .clamp(0, timerProvider.initialSeconds) /
                            timerProvider.initialSeconds,
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
                            _showCancelDialog(context);
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
                            timerProvider.isRunning
                                ? timerProvider.pauseTimer()
                                : timerProvider.resumeTimer();
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
                            timerProvider.resetTimer();
                            String startTime = DateFormat('yyyy-MM-dd HH:mm:ss')
                                .format(DateTime.now()
                                    .subtract(Duration(minutes: 46)));
                            String endTime = DateFormat('yyyy-MM-dd HH:mm:ss')
                                .format(DateTime.now());
                            if (false) {
                              print("object : Offline");
                              var meditationData = MeditationData(
                                  startTime: startTime, endTime: endTime);
                              box.add(meditationData);
                              buttonStateNotifier.disableButton();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MeditationNote()),
                              );
                            } else {
                              print("object : else");
                              meditation.meditationTime(startTime.toString(), endTime);
                              buttonStateNotifier.disableButton();
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MeditationNote()),
                              );
                            }
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24),
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
