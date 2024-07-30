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
    Provider.of<ButtonStateNotifier>(context,listen: false).loadButtonState();
    Provider.of<AppLogin>(context, listen: false).validateSession(context);
    Provider.of<ZoomMeetingController>(context, listen: false).zoomClass();
    Provider.of<PaymentController>(context, listen: false).financialConfiguration();
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
    Provider.of<ConnectivityProvider>(context, listen: false).initConnectivity();
    var id = Provider.of<AppLogin>(context, listen: false).userData?.uId ?? "";
    Provider.of<MeditationController>(context, listen: false)
        .meditationTimeDetails(context);
    Provider.of<MeditationController>(context, listen: false)
        .meditationDetailsTime();
    uploadMeditationTimes();
  }

  void uploadMeditationTimes() async {
    if(Provider.of<ConnectivityProvider>(context, listen: false).status != ConnectivityStatus.Offline){
      var box = await Hive.openBox<MeditationData>('MeditationDataBox');
      print("entered");
      for (int index = 0; index < box.length; index++) {
        MeditationData? db = box.getAt(index);
        if (db != null) {
          print("check data : ${db.startTime}, ${db.endTime}");
          Provider.of<MeditationController>(context, listen: false).meditationTime(db.startTime, db.endTime).then((_) {box.deleteAt(index);
          });
        }
      }
    }
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
    var connect = Provider.of<ConnectivityProvider>(context);
    var appLogin = Provider.of<AppLogin>(context);
    var overView = Provider.of<OverViewController>(context).eventLIst;
    var blogsLIst = Provider.of<OverViewController>(context).blogsLIst;
    var flagModel = Provider.of<AppLogin>(context).flagModel;
    var zoomMeet = Provider.of<ZoomMeetingController>(context).ZoomClassModelData;

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
        child: connect.status == ConnectivityStatus.Offline
            ? Center(child: RefreshPage(
                onTap: () {
                  Provider.of<AppLogin>(context, listen: false).getUserByID();
                  Provider.of<AppLogin>(context, listen: false)
                      .importantFlags();
                  Provider.of<OverViewController>(context, listen: false)
                      .eventList();
                  Provider.of<ConnectivityProvider>(context, listen: false)
                      .status;
                  Provider.of<ZoomMeetingController>(context, listen: false)
                      .zoomClass();
                },
              ))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        slidePageRoute(context, Profile());
                        // Navigator.push(context,MaterialPageRoute(builder: (context) => Profile(),));
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 16.sp, right: 16.sp, top: 16.sp),
                        child: Container(
                          height: 192.h,
                          decoration: BoxDecoration(
                            border: Border.fromBorderSide(BorderSide.none),
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(
                                    "assets/images/overviewimg1.jpg")),
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
                              padding: EdgeInsets.fromLTRB(
                                  16.sp, 16.sp, 32.sp, 16.sp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                    InkWell(
                      onTap: (){
                        indexProvider.currentIndex = 2;
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.sp, right: 16.sp),
                        child: Container(
                          height: 176.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.amber.shade100, // Lighter color
                                Colors.amber.shade50, // Lighter color
                                Colors.amber.shade50, // Lighter color
                              ],
                              // stops: [0.0, 1.0],
                            ),
                            border: Border.fromBorderSide(BorderSide.none),
                            borderRadius: BorderRadius.circular(12.sp),
                          ),
                          child: Padding(
                            padding:
                                EdgeInsets.fromLTRB(16.sp, 8.sp, 16.sp, 8.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Meditation Cycle"),
                                spaceBetween,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.self_improvement,
                                      size: 80.sp,
                                    ),
                                    Container(
                                      height: 100.h,
                                      width: 1.w,
                                      color: brown,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Completed Cycle"),
                                        spaceBetween,
                                        Text("Current Cycle"),
                                        spaceBetween,
                                        Text("Days Completed"),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text("${appLogin.userData?.cycle ?? 0}"),
                                        spaceBetween,
                                        Text("${appLogin.userData?.cycle ?? 0}"),
                                        spaceBetween,
                                        Text("${appLogin.userData?.day ?? 0}"),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Events",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    overView.isEmpty
                        ? Padding(
                            padding: EdgeInsets.only(left: 16.sp, right: 16.sp),
                            child: Container(
                              height: 176.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.amber.shade100, // Lighter color
                                    Colors.amber.shade50, // Lighter color
                                    Colors.amber.shade50, // Lighter color
                                  ],
                                ),
                                border: Border.fromBorderSide(BorderSide.none),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(child: Text("No Events")),
                            ),
                          )
                        : CarouselSlider.builder(
                            itemCount: overView.length,
                            itemBuilder: (BuildContext context, int itemIndex,
                                int pageViewIndex) {
                              return SizedBox(
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet<void>(
                                      backgroundColor: shadeOne,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SizedBox(
                                           width: MediaQuery.of(context).size.width,
                                          child: Container(
                                            padding: EdgeInsets.all(16),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 100.w,
                                                      height: 120.h,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(8),
                                                        image: overView[itemIndex]
                                                            .image !=
                                                            null
                                                            ? DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image: NetworkImage(
                                                              "${overView[itemIndex].image}"),
                                                        )
                                                            : null,
                                                      ),
                                                      child: overView[itemIndex]
                                                          .image ==
                                                          null
                                                          ? Center(
                                                        child: Text(
                                                          "No Image Available",
                                                          textAlign:
                                                          TextAlign.center,
                                                        ),
                                                      )
                                                          : null,
                                                    ),
                                                    SizedBox(height: 16.h),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: MediaQuery.of(context).size.width - 150,
                                                            child: Text(
                                                              "${overView[itemIndex].eventName}",
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            "${overView[itemIndex].date != null ? overView[itemIndex].date.toString() : 'N/A'} (${overView[itemIndex].eventTime})",
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8.h),
                                                Expanded(
                                                  child: Scrollbar(
                                                    thickness: 5,
                                                    radius: Radius.circular(2),
                                                    interactive: true,
                                                    thumbVisibility: true,
                                                    child:
                                                        SingleChildScrollView(
                                                            child: Text(
                                                      "${overView[itemIndex].eventDescription}",
                                                    )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 16.sp, right: 16.sp),
                                    child: Container(
                                      height: 176.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.amber
                                                .shade100, // Lighter color
                                            Colors
                                                .amber.shade50, // Lighter color
                                            Colors
                                                .amber.shade50, // Lighter color
                                          ],
                                        ),
                                        border: Border.fromBorderSide(
                                            BorderSide.none),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(4.sp),
                                            child: Padding(
                                              padding: EdgeInsets.all(8.sp),
                                              child: Container(
                                                width: 122.w,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  image: overView[itemIndex]
                                                              .image !=
                                                          null
                                                      ? DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image: NetworkImage(
                                                              "${overView[itemIndex].image}"),
                                                        )
                                                      : null,
                                                ),
                                                child: overView[itemIndex]
                                                            .image ==
                                                        null
                                                    ? Center(
                                                        child: Text(
                                                          "No Image Available",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      )
                                                    : null,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Spacer(),
                                              Container(
                                                width: 200.w,
                                                child: Text(
                                                  "${overView[itemIndex].eventName}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 14.sp,
                                                      color: darkShade,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Spacer(),
                                              Row(
                                                children: [
                                                  Icon(Icons
                                                      .event_repeat_rounded),
                                                  Text(
                                                    // "${overView[itemIndex].date != null ? DateFormat('dd/MM/yyyy').format(overView[itemIndex].date!) : 'N/A'} (${overView[itemIndex].eventTime})",
                                                    "${overView[itemIndex].date != null ? overView[itemIndex].date.toString() : 'N/A'} (${overView[itemIndex].eventTime})",
                                                    style: TextStyle(
                                                        fontSize: 12.sp,
                                                        color: darkShade),
                                                  )
                                                ],
                                              ),
                                              Spacer(),
                                              Container(
                                                  width: 200.w,
                                                  child: Text(
                                                    "${overView[itemIndex].eventDescription}",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: eventSubText,
                                                      // Maximum number of lines
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    maxLines: 4,
                                                  )),
                                              Spacer()
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            options: CarouselOptions(
                              height: 170,
                              aspectRatio: 16 / 9,
                              viewportFraction: 1,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: overView.length == 1 ? false : true,
                              autoPlayInterval: Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.1,
                              // onPageChanged: callbackFunction,
                              scrollDirection: Axis.horizontal,
                            )),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Blogs",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    blogsLIst.isEmpty
                        ? Padding(
                            padding: EdgeInsets.only(left: 16.sp, right: 16.sp),
                            child: Container(
                              height: 176.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.amber.shade100, // Lighter color
                                    Colors.amber.shade50, // Lighter color
                                    Colors.amber.shade50, // Lighter color
                                  ],
                                ),
                                border: Border.fromBorderSide(BorderSide.none),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(child: Text("No Blogs")),
                            ),
                          )
                        : CarouselSlider.builder(
                            itemCount: blogsLIst.length,
                            itemBuilder: (BuildContext context, int itemIndex,
                                int pageViewIndex) {
                              return SizedBox(
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet<void>(
                                      backgroundColor: shadeOne,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SizedBox(
                                          // height: 500.h,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Container(
                                            padding: EdgeInsets.all(16),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    Container(
                                                      height: 120.h,
                                                      width: 100.w,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        image: DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image: NetworkImage(
                                                              "${blogsLIst[itemIndex].image}"),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 16.h),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                150,
                                                            child: Text(
                                                              "${blogsLIst[itemIndex].blogName}",
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            "${blogsLIst[itemIndex].date != null ? blogsLIst[itemIndex].date.toString() : 'N/A'}",
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8.h),
                                                Expanded(
                                                  child: Scrollbar(
                                                    thickness: 5,
                                                    radius: Radius.circular(2),
                                                    interactive: true,
                                                    thumbVisibility: true,
                                                    child:
                                                        SingleChildScrollView(
                                                            child: Text(
                                                      "${blogsLIst[itemIndex].blogDescription}",
                                                    )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 16.sp, right: 16.sp),
                                    child: Container(
                                      height: 176.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.amber
                                                .shade100, // Lighter color
                                            Colors
                                                .amber.shade50, // Lighter color
                                            Colors
                                                .amber.shade50, // Lighter color
                                          ],
                                        ),
                                        border: Border.fromBorderSide(
                                            BorderSide.none),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(4.sp),
                                            child: Padding(
                                              padding: EdgeInsets.all(8.sp),
                                              child: Container(
                                                width: 122.w,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  image: blogsLIst[itemIndex]
                                                              .image !=
                                                          null
                                                      ? DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image: NetworkImage(
                                                              "${blogsLIst[itemIndex].image}"),
                                                        )
                                                      : null,
                                                ),
                                                child: blogsLIst[itemIndex]
                                                            .image ==
                                                        null
                                                    ? Center(
                                                        child: Text(
                                                          "No Image Available",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      )
                                                    : null,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Spacer(),
                                              Container(
                                                width: 200.w,
                                                child: Text(
                                                  "${blogsLIst[itemIndex].blogName}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 14.sp,
                                                      color: darkShade,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Spacer(),
                                              Row(
                                                children: [
                                                  Icon(Icons
                                                      .event_repeat_rounded),
                                                  Text(
                                                    // "${overView[itemIndex].date != null ? DateFormat('dd/MM/yyyy').format(overView[itemIndex].date!) : 'N/A'} (${overView[itemIndex].eventTime})",
                                                    "${blogsLIst[itemIndex].date != null ? blogsLIst[itemIndex].date.toString() : 'N/A'} ",
                                                    style: TextStyle(
                                                        fontSize: 12.sp,
                                                        color: darkShade),
                                                  )
                                                ],
                                              ),
                                              Spacer(),
                                              Container(
                                                  width: 200.w,
                                                  child: Text(
                                                    "${blogsLIst[itemIndex].blogDescription}",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: eventSubText,
                                                      // Maximum number of lines
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    maxLines: 4,
                                                  )),
                                              Spacer()
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            options: CarouselOptions(
                              height: 170,
                              aspectRatio: 16 / 9,
                              viewportFraction: 1,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: blogsLIst.length == 1 ? false : true,
                              autoPlayInterval: Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.1,
                              // onPageChanged: callbackFunction,
                              scrollDirection: Axis.horizontal,
                            )),
                    // DotsIndicator(
                    //   dotsCount: 5,
                    //   position: _currentIndex,
                    // ),
                    SizedBox(
                      height: 16,
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

