import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';
import 'package:thusmai_appointmrent/controller/payment_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/connectivitycontroller.dart';
import '../../controller/disable_meditation.dart';
import '../../controller/login_register_otp_api.dart';
import '../../controller/meditationController.dart';
import '../../controller/overviewController.dart';
import '../../controller/zoommeeting_controller.dart';
import '../../models/hive/meditationdata.dart';
import '../../widgets/additionnalwidget.dart';
import '../../widgets/carosal_widget.dart';
import '../../widgets/homeboxes.dart';
import '../../widgets/popup_widget.dart';
import '../profile/profile.dart';
import '../refreshpage.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    Provider.of<ButtonStateNotifier>(context, listen: false).loadButtonState();
    Provider.of<AppLogin>(context, listen: false).validateSession(context);
    Provider.of<ZoomMeetingController>(context, listen: false).zoomClass();
    Provider.of<PaymentController>(context, listen: false)
        .financialConfiguration();
    _timer = Timer.periodic(Duration(minutes: 15), (timer) {
      Provider.of<ZoomMeetingController>(context, listen: false).zoomClass();
    });
    // Initialize the AnimationController
    _controller = AnimationController(
      vsync: this, // SingleTickerProviderStateMixin provides vsync
      duration: Duration(milliseconds: 500), // Duration of one heartbeat cycle
    )..repeat(
        reverse:
            true); // Repeat the animation in reverse to create a heartbeat effect

    // Define the scaling animation

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    Provider.of<AppLogin>(context, listen: false).getUserByID();
    Provider.of<AppLogin>(context, listen: false).importantFlags();
    Provider.of<OverViewController>(context, listen: false).eventList();
    Provider.of<OverViewController>(context, listen: false).blogs();
    // Provider.of<ConnectivityProvider>(context, listen: false).initConnectivity();
    var id = Provider.of<AppLogin>(context, listen: false).userData?.uId ?? "";
    Provider.of<MeditationController>(context, listen: false)
        .meditationTimeDetails(context);
    Provider.of<MeditationController>(context, listen: false)
        .meditationDetailsTime();
    uploadMeditationTimes();
  }

  void uploadMeditationTimes() async {
    // if(Provider.of<ConnectivityProvider>(context, listen: false).status != ConnectivityStatus.Offline){
    var box = await Hive.openBox<MeditationData>('MeditationDataBox');
    print("entered");
    for (int index = 0; index < box.length; index++) {
      MeditationData? db = box.getAt(index);
      if (db != null) {
        print("check data : ${db.startTime}, ${db.endTime}");
        Provider.of<MeditationController>(context, listen: false)
            .meditationTime(db.startTime, db.endTime)
            .then((_) {
          box.deleteAt(index);
        });
      }
    }
    // }
  }

  @override
  void dispose() {
    // Clean up resources when the widget is removed from the widget tree
    // Provider.of<AppLogin>(context, listen: false).dispose();
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  bool isBeforeStopTime(String? zoomStopTime) {
    // Return false if the zoomStopTime is null
    if (zoomStopTime == null) {
      return false;
    }

    // Split the stop time string and extract the hour, minute, and period (AM/PM)
    List<String> parts = zoomStopTime.split(" ");
    String timePart = parts[0]; // "10:00"
    String periodPart = parts[1]; // "PM"

    List<String> timeComponents = timePart.split(":");
    int stopHour = int.parse(timeComponents[0]);
    int stopMinute = int.parse(timeComponents[1]);

    // Adjust the stop hour based on the period (AM/PM)
    if (periodPart == "PM" && stopHour != 12) {
      stopHour += 12;
    } else if (periodPart == "AM" && stopHour == 12) {
      stopHour = 0; // Midnight case
    }

    // Get the current hour and minute in 24-hour format
    DateTime now = DateTime.now();
    int currentHour = now.hour;
    int currentMinute = now.minute;

    // Compare the current time with the stop time

    if (currentHour < stopHour) {
      return true;
    } else if (currentHour == stopHour) {
      return currentMinute <= stopMinute;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var indexProvider = Provider.of<AppLogin>(context);
    var id = Provider.of<AppLogin>(context, listen: false).userData?.uId ?? "";
    Provider.of<MeditationController>(context, listen: false)
        .meditationTimeDetails(context);
    // var connect = Provider.of<ConnectivityProvider>(context);
    var appLogin = Provider.of<AppLogin>(context);
    var eventLIst = Provider.of<OverViewController>(context).eventLIst;
    var blogsLIst = Provider.of<OverViewController>(context).blogsLIst;
    var flagModel = Provider.of<AppLogin>(context).flagModel;
    var zoomMeet =
        Provider.of<ZoomMeetingController>(context).ZoomClassModelData;

    // String? firstName =
    //     appLogin.userData?.firstName; // Get the first name, if available
    // String? lastName =
    //     appLogin.userData?.lastName; // Get the last name, if available
    // String capitalizedFirstName = firstName != null
    //     ? firstName[0].toUpperCase() + firstName.substring(1)
    //     : ""; // Capitalize the first letter of first name if not null
    // String capitalizedLastName = lastName != null
    //     ? lastName[0].toUpperCase() + lastName.substring(1)
    //     : ""; // Capitalize the first letter of last name if not null
    return Scaffold(
      floatingActionButton: flagModel.maintenancePaymentStatus == false
          ? null
          : zoomMeet.zoomLink == ""
              ? null
              : zoomMeet.zoomLink == null
                  ? const Center(child: CircularProgressIndicator())
                  : isBeforeStopTime(zoomMeet.zoomStopTime.toString()) == false
                      ? null
                      : Stack(
                          alignment: Alignment.center,
                          children: [
                            ScaleTransition(
                              scale: _animation, // Apply the scaling animation
                              child: Container(
                                width:
                                    60, // default size of FloatingActionButton
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: flagModel.maintenancePaymentStatus ==
                                          false
                                      ? Colors.grey
                                      : Colors.blue.withOpacity(0.5),
                                ),
                              ),
                            ),
                            FloatingActionButton(
                              heroTag: 1,
                              backgroundColor:
                                  flagModel.meditationFeePaymentStatus == false
                                      ? Colors.grey
                                      : Colors.blue,
                              // replace shadeEight with your color
                              onPressed:
                                  flagModel.meditationFeePaymentStatus == false
                                      ? () {
                                          appLogin.currentIndex = 3;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Text(enableMessage),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        }
                                      : () {
                                          Provider.of<ZoomMeetingController>(
                                                  context,
                                                  listen: false)
                                              .zoomPost();
                                          launchUrl(Uri.parse(
                                              zoomMeet.zoomLink.toString()));
                                        },
                              child: Icon(
                                Icons.video_call_outlined,
                                size: 30,
                                color: Colors
                                    .white, // replace darkShade with your color
                              ),
                              mini: false,
                            ),
                          ],
                        ),
      backgroundColor: shadeOne,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  slidePageRoute(context, Profile());
                  // Navigator.push(context,MaterialPageRoute(builder: (context) => Profile(),));
                },
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 16.sp, right: 16.sp, top: 16.sp),
                  child: Container(
                    height: 192.h,
                    decoration: BoxDecoration(
                      border: Border.fromBorderSide(BorderSide.none),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage("assets/images/overviewimg1.jpg")),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: <Color>[
                            Colors.white.withOpacity(1),
                            Colors.white.withOpacity(.6),
                            Colors.white.withOpacity(.0),
                            Colors.white.withOpacity(.0),
                            Colors.white.withOpacity(.0),
                            Colors.white.withOpacity(.0),
                          ],
                          // Gradient from https://learnui.design/tools/gradient-generator.html
                          tileMode: TileMode.mirror,
                        ),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.fromLTRB(16.sp, 16.sp, 32.sp, 16.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.account_box,
                                      size: 30.sp,
                                    ),
                                    SizedBox(
                                      width: 2.sp,
                                    ),
                                    Text(
                                      "${appLogin.userData?.firstName}  ${appLogin.userData?.lastName}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.sp),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "Card No : TSL${appLogin.userData?.uId}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.sp),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "DOJ : ${appLogin.userData?.doj != null ? DateFormat('dd/MM/yyyy').format(appLogin.userData!.doj!) : 'N/A'}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  "VALID :  ${appLogin.userData?.expiredDate != null ? DateFormat('dd/MM/yyyy').format(appLogin.userData!.expiredDate!) : 'N/A'}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              spaceBetween,
              Row(
                children: [
                  SizedBox(
                    height: 176.h,
                    width: MediaQuery.of(context).size.width / 2,
                    child: MeditationCard(
                      iconData: Icons.self_improvement,
                      title: "Meditation",
                      background: meditationColor,
                      valueData: true,
                      dataStringOne: "Current Cycle",
                      dataStringTwo: "Days Completed",
                      onTap: () {
                        indexProvider.currentIndex = 2;
                      },
                      currentCycle: appLogin.userData?.cycle ?? 0,
                      daysCompleted: appLogin.userData?.day ?? 0,
                    ),
                  ),
                  BlogImageCarousel(
                    blogsList: blogsLIst,
                    titleName: 'Recent Blogs',
                    backgroundColor: sliderBackground1,
                  ),
                ],
              ),
              SizedBox(
                height: 8.h,
              ),
              Row(
                children: [
                  BlogImageCarousel(
                    blogsList: eventLIst,
                    titleName: 'Recent Events',
                    backgroundColor: sliderBackground2,
                  ),
                  SizedBox(
                    height: 176.h,
                    width: MediaQuery.of(context).size.width / 2,
                    child: MeditationCard(
                      iconData: Icons.message_outlined,
                      title: "t-tok and Guruji",
                      background: messageGuruColor,
                      valueData: false,
                      dataStringOne: "Connecting Hearts and ",
                      dataStringTwo: "Minds Across the Globe",
                      onTap: () {
                        indexProvider.currentIndex = 3;
                      },
                      currentCycle: appLogin.userData?.cycle ?? 0,
                      daysCompleted: appLogin.userData?.day ?? 0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
            ],
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
