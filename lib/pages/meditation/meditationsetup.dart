import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/widgets/shimmerwidget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/connectivitycontroller.dart';
import '../../controller/disable_meditation.dart';
import '../../controller/login_register_otp_api.dart';
import '../../controller/meditationController.dart';
import '../../widgets/additionnalwidget.dart';
import '../refreshpage.dart';
import 'meditationtimer.dart';
import '../../constant/constant.dart';

class MeditationCycle extends StatefulWidget {
  const MeditationCycle({Key? key}) : super(key: key);

  @override
  State<MeditationCycle> createState() => _MeditationCycleState();
}

class _MeditationCycleState extends State<MeditationCycle> {
  bool isPressed = false;
  Color amberColor = Colors.amber;

  @override
  void initState() {
    super.initState();
    final meditationController =
        Provider.of<MeditationController>(context, listen: false);
    final appLoginProvider = Provider.of<AppLogin>(context, listen: false);
    Provider.of<AppLogin>(context, listen: false).validateSession(context);
    Provider.of<ButtonStateNotifier>(context, listen: false).loadButtonState();
    appLoginProvider.getUserByID();
    appLoginProvider.importantFlags();
    meditationController.meditationTimeDetails(context);
    meditationController.meditationDetailsTime();
    meditationController.buttonBlockRequest();
  }

  String convertToAmPm(String time) {
    final timeParts = time.split(":");
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    String period = hour >= 12 ? "PM" : "AM";
    hour = hour % 12;
    hour = hour == 0 ? 12 : hour;
    final minuteString = minute.toString().padLeft(2, '0');
    return "$hour:$minuteString $period";
  }

  String getYoutubeThumbnail(String url) {
    final uri = Uri.parse(url);
    final videoId =
        uri.queryParameters['v']?.trim() ?? uri.pathSegments.last.trim();
    return 'https://img.youtube.com/vi/$videoId/0.jpg';
  }

  Future<void> launchURL(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch URL');
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonStateNotifier = Provider.of<ButtonStateNotifier>(context);
    final appLoginProvider = Provider.of<AppLogin>(context);
    // final connectivityProvider = Provider.of<ConnectivityProvider>(context);
    final meditationController = Provider.of<MeditationController>(context);
    final meditationFullTime = meditationController.meditationFullTime;
    final meditationTimeData = meditationController.meditationTimeData;
    final flagModel = appLoginProvider.flagModel;
    print(flagModel.meditationFeePaymentStatus.toString());
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
                          "${appLoginProvider.userData?.day ?? 0}",
                          "${appLoginProvider.userData?.cycle ?? 0}",
                          "${appLoginProvider.userData?.cycle ?? 0}"),
                      Container(
                        width: 2,
                        height: 208,
                        color: shadeEight,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          meditationFullTime.morningTimeTo == null
                              ? ShimmerContainer(width: 90.w, height: 90.h)
                              : Row(
                                  children: [
                                    timeSetup(
                                        "Morning",
                                        convertToAmPm(meditationFullTime
                                                .morningTimeFrom ??
                                            ""),
                                        convertToAmPm(
                                            meditationFullTime.morningTimeTo ??
                                                "")),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: 90.w,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                              color: isCurrentTimeBetween(
                                                      meditationFullTime
                                                              .morningTimeFrom ??
                                                          "",
                                                      meditationFullTime
                                                              .morningTimeTo ??
                                                          "")
                                                  ? amberColor
                                                  : Colors.grey),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Image.asset(
                                              "assets/images/sun.png"),
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
                          meditationFullTime.morningTimeTo == null
                              ? ShimmerContainer(width: 90.w, height: 90.h)
                              : Row(
                                  children: [
                                    timeSetup(
                                        "Evening",
                                        meditationFullTime.eveningTimeFrom
                                                    .toString()
                                                    .length <
                                                4
                                            ? "N/A"
                                            : convertToAmPm(meditationFullTime
                                                    .eveningTimeFrom ??
                                                ""),
                                        meditationFullTime.eveningTimeTo
                                                    .toString()
                                                    .length <
                                                4
                                            ? "N/A"
                                            : convertToAmPm(meditationFullTime
                                                    .eveningTimeTo ??
                                                "")),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Container(
                                        width: 90.w,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                              color: isCurrentTimeBetween(
                                                      meditationFullTime
                                                              .eveningTimeFrom ??
                                                          "",
                                                      meditationFullTime
                                                              .eveningTimeTo ??
                                                          "")
                                                  ? amberColor
                                                  : Colors.grey),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Image.asset(
                                              "assets/images/moon.png"),
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
                      final videoUrl =
                          Uri.parse(meditationTimeData.video ?? "");
                      meditationTimeData.video == null
                          ? null
                          : launchURL(videoUrl);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          meditationTimeData.video == null
                              ? ShimmerContainer(
                                  width: MediaQuery.of(context).size.width,
                                  height: 200.h)
                              : Container(
                                  height: 210.h,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        meditationTimeData.video == null
                                            ? imgFromFirebase
                                            : getYoutubeThumbnail(
                                                meditationTimeData.video ?? ""),
                                      ),
                                    ),
                                  ),
                                ),
                          meditationTimeData.video == null
                              ? Container()
                              : Icon(
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
                          if (buttonStateNotifier.meditationDisable == false) {
                            if (isCurrentTimeBetween(
                                meditationTimeData.fromTime ?? "",
                                meditationTimeData.toTime ?? "")) {
                              slidePageRoute(context, TimerScreen());
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Sorry, you are not able to meditate now"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Sorry, your meditation is already completed."),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } else {
                          appLoginProvider.currentIndex = 4;
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
                        backgroundColor: flagModel.meditationFeePaymentStatus ==
                                    true &&
                                buttonStateNotifier.meditationDisable != true
                            ? goldShade
                            : Colors.grey,
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
