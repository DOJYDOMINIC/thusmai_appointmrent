import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';
import '../../controller/login_register_otp_api.dart';
import '../../controller/overviewController.dart';


class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  @override
  void initState() {
    super.initState();
    Provider.of<AppLogin>(context, listen: false).getUserByID();
    Provider.of<AppLogin>(context, listen: false).importantFlags();
    Provider.of<OverViewController>(context, listen: false).eventList();
    // Provider.of<AppLogin>(context, listen: false).tokenSave();

  }


  @override
  void dispose() {
    // Clean up resources when the widget is removed from the widget tree
    // Provider.of<AppLogin>(context, listen: false).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appLogin = Provider.of<AppLogin>(context);
    var overView = Provider.of<OverViewController>(context).eventLIst;
    String? firstName =
        appLogin.userData?.firstName; // Get the first name, if available
    String? lastName =
        appLogin.userData?.lastName; // Get the last name, if available
    String capitalizedFirstName = firstName != null
        ? firstName[0].toUpperCase() + firstName.substring(1)
        : ""; // Capitalize the first letter of first name if not null
    String capitalizedLastName = lastName != null
        ? lastName[0].toUpperCase() + lastName.substring(1)
        : ""; // Capitalize the first letter of last name if not null
    return Scaffold(
      backgroundColor: shadeOne,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  // Provider.of<PaymentController>(context, listen: false).processPayment(context, appLogin.userData?.uId);
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
                                      "${capitalizedFirstName}  ${capitalizedLastName}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.sp),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "Card No : ${appLogin.userData?.uId}",
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
              Padding(
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
                    padding: EdgeInsets.fromLTRB(16.sp, 8.sp, 16.sp, 8.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Meditation Cycle"),
                        spaceBetween,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
              spaceBetween,
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
                                    height: 400.h,
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
                                                height: 150.h,
                                                width: 100.w,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                            "${overView[itemIndex].image}"))),
                                              ),
                                              SizedBox(height: 16.h),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              150,
                                                      child: Text(
                                                        "${overView[itemIndex].eventName}",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "${overView[itemIndex].date != null ? overView[itemIndex].date.toString() : 'N/A'} (${overView[itemIndex].eventTime})",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                              child: SingleChildScrollView(
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
                              padding:
                                  EdgeInsets.only(left: 16.sp, right: 16.sp),
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
                                  border:
                                      Border.fromBorderSide(BorderSide.none),
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
                                      borderRadius: BorderRadius.circular(8),
                                      image: overView[itemIndex].image != null
                                          ? DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage("${overView[itemIndex].image}"),
                                      )
                                          : null,
                                    ),
                                    child: overView[itemIndex].image == null
                                        ? Center(child: Text("No Image Available",textAlign: TextAlign.center,),)
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
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                color: darkShade,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Spacer(),
                                        Row(
                                          children: [
                                            Icon(Icons.event_repeat_rounded),
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
                                                overflow: TextOverflow.ellipsis,
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
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.1,
                        // onPageChanged: callbackFunction,
                        scrollDirection: Axis.horizontal,
                      )),
            ],
          ),
        ),
      ),
    );
  }
}
