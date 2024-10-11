import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constant/constant.dart';
import '../controller/connectivitycontroller.dart';
import '../controller/login_register_otp_api.dart';

Widget timeSetup(String head, String startTime, String endTime) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        head,
        style: TextStyle(
          color: darkShade,
          fontSize: 14.sp,
        ),
      ),
      SizedBox(
        height: 8.h,
      ),
      Column(
        children: [
          Text(
            startTime,
            style: TextStyle(
                color: darkShade, fontSize: 12.sp, fontWeight: FontWeight.w500),
          ),
          Text(
            "to",
            style: TextStyle(
                color: darkShade, fontSize: 12.sp, fontWeight: FontWeight.w500),
          ),
          Text(
            endTime,
            style: TextStyle(
                color: darkShade, fontSize: 12.sp, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ],
  );
}

Widget meditationCycleWidget(
    String head, String day, String currentCycle, String cycleCompeted) {
  return Row(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            head,
            style: TextStyle(color: darkShade, fontWeight: FontWeight.w500),
          ),
          spaceBetween,
          Text("Day"),
          // spaceBetween,
          // Text("Current Cycle"),
          spaceBetween,
          Text("Cycle Completed"),
        ],
      ),
      SizedBox(
        width: 16.w,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(""),
          spaceBetween,
          Text(day),
          // spaceBetween,
          // Text(currentCycle),
          spaceBetween,
          Text(cycleCompeted),
        ],
      ),
    ],
  );
}

Widget profileCard(BuildContext context) {
  var pro = Provider.of<AppLogin>(context);
  // var connect = Provider.of<ConnectivityProvider>(context);

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${pro.userData?.firstName ?? ""} ${pro.userData?.lastName ?? ""}",
              style: TextStyle(fontSize: 22.sp),
              overflow: TextOverflow.ellipsis,
            ),
            Text("Card no : TSL${pro.userData?.uId ?? ""}",
                overflow: TextOverflow.ellipsis),
            Text(pro.userData?.phone ?? "", overflow: TextOverflow.ellipsis),
            Text(pro.userData?.email ?? "", overflow: TextOverflow.ellipsis),
            Text(
              "DOJ : ${pro.userData?.doj != null ? DateFormat('dd/MM/yyyy').format(pro.userData!.doj!) : 'N/A'}",
            ),
          ],
        ),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 48.sp,
            backgroundColor: goldShade,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 45.sp,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: pro.userData?.profilePicUrl != null
                        ? NetworkImage("${pro.userData?.profilePicUrl}")
                        : NetworkImage(imgFromFirebase),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Text(
            // "Valid : ${pro.userData?.expiredDate.toString().split(" ").first ?? ""}",),
            "Valid : ${pro.userData?.expiredDate != null ? DateFormat('dd/MM/yyyy').format(pro.userData!.expiredDate!) : 'N/A'}",
          ),
        ],
      )
    ],
  );
}

Widget referReward(String img, String text, void Function()? onTap) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: 112.h,
        decoration: BoxDecoration(
          color: shadeSix,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset:
                  Offset(0, 5), // Positive vertical offset for bottom shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              img,
              color: darkShade,
              width: 35.w,
              height: 35.h,
            ),
            Text(
              text,
              style: TextStyle(fontSize: 22),
            )
          ],
        ),
      ),
    ),
  );
}

Widget buttonData(String head, IconData icon) {
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 40, left: 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              icon,
              size: 40,
              color: head == "Cancel" ? midRed : darkShade,
            ),
            Text(
              head,
              style: TextStyle(
                  color: head == "Cancel" ? midRed : darkShade,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    ],
  );
}

class QuarterCircleContainer extends StatelessWidget {
  final double size;
  final Color color;
  final Widget child;
  final bool status;

  QuarterCircleContainer(
      {required this.size,
      required this.color,
      required this.child,
      required this.status});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: QuarterCircleClipper(status: status),
      child: Container(
        width: size,
        height: size,
        color: color,
        child: child,
      ),
    );
  }
}

class QuarterCircleClipper extends CustomClipper<Path> {
  final bool status;

  QuarterCircleClipper({required this.status});

  @override
  Path getClip(Size size) {
    final path = Path();
    final double radius = size.width;

    if (status) {
      // Start from the top-left corner
      path.moveTo(0, radius);

      // Draw a quarter circle arc from top-left to top-right
      path.arcToPoint(
        Offset(radius, 0),
        radius: Radius.circular(radius),
        clockwise: true,
      );

      // Line to the bottom-right corner
      path.lineTo(size.width, size.height);

      // Line to the bottom-left corner
      path.lineTo(0, size.height);

      // Close the path
      path.close();
    } else {
      // Start from the top-right corner
      path.moveTo(size.width, radius);

      // Draw a quarter circle arc from top-right to top-left
      path.arcToPoint(
        Offset(0, 0),
        radius: Radius.circular(radius),
        clockwise: false,
      );

      // Line to the bottom-left corner
      path.lineTo(0, size.height);

      // Line to the bottom-right corner
      path.lineTo(size.width, size.height);

      // Close the path
      path.close();
    }
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class HalfCircleClipper extends CustomClipper<Path> {
  HalfCircleClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    final double radius = size.width / 2;

    // Start from the top-left corner
    path.moveTo(0, radius);

    // Draw a half circle arc from top-left to top-right
    path.arcTo(
      Rect.fromCircle(center: Offset(radius, radius), radius: radius),
      0,
      -pi,
      false,
    );

    // // Line to the bottom-right corner
    // path.lineTo(size.width, size.height);
    //
    // // Line to the bottom-left corner
    // path.lineTo(0, size.height);

    // Close the path
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

Future slidePageRoute(
  BuildContext context,
  Widget page,
) {
  return Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secAnimation, Widget child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secAnimation) {
        return page; // Change Profile() to the variable 'page'
      },
    ),
  );
}

// change asset image to network image on api call
Widget rewardWidget(String title, String description, days) {
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.only(left: 8.sp, right: 8.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Text(title),
                // Padding(
                //   padding: EdgeInsets.all(8.sp),
                //   child: Image(
                //       width: 56.w,
                //       height: 56.h,
                //       fit: BoxFit.cover,
                //       image: AssetImage(imgLink)),
                // ),
                SizedBox(
                  width: 16.w,
                ),
                Container(
                  width: 200.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title),
                      Text(description),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  days,
                  style: TextStyle(
                      color: darkShade,
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp),
                ),
                // ElevatedButton(
                //     style: ButtonStyle(
                //         backgroundColor: MaterialStatePropertyAll(goldShade)),
                //     onPressed: () {
                //       launchURL(url);
                //     },
                //     child: Text(
                //       "share",
                //       style: TextStyle(
                //           color: darkShade, fontWeight: FontWeight.w400),
                //     ))
              ],
            )
          ],
        ),
      ),
      Divider(
        color: darkShade,
      )
    ],
  );
}

launchURL(Uri url) async {
  if (!await launchUrl(url)) {
    throw Exception('Could not launch url');
  }
}

// change asset image to network image on api call
Widget transactionWidget(IconData icon, String date, String title,
    String description, String amount, void Function()? onPressed) {
  return Column(
    children: [
      SizedBox(
        child: Padding(
          padding: EdgeInsets.only(left: 8.sp, right: 8.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Icon(
                        icon,
                        size: 46,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        date,
                        style: TextStyle(fontSize: 10),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(description),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    amount,
                    style: TextStyle(
                        color: darkShade,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp),
                  ),
                  IconButton(
                    onPressed: onPressed,
                    icon: Icon(
                      Icons.copy,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      Divider(
        color: shadeThree,
      )
    ],
  );
}

bool isCurrentTimeBetween(String fromTime, String toTime) {
  if (fromTime == "" || toTime == "") {
    return false;
  }

  TimeOfDay from = TimeOfDay(
    hour: int.parse(fromTime.split(":")[0]),
    minute: int.parse(fromTime.split(":")[1]),
  );

  TimeOfDay to = TimeOfDay(
    hour: int.parse(toTime.split(":")[0]),
    minute: int.parse(toTime.split(":")[1]),
  );

  TimeOfDay now = TimeOfDay.now();

  if (from.hour < to.hour ||
      (from.hour == to.hour && from.minute <= to.minute)) {
    return (now.hour > from.hour ||
            (now.hour == from.hour && now.minute >= from.minute)) &&
        (now.hour < to.hour ||
            (now.hour == to.hour && now.minute <= to.minute));
  } else {
    return (now.hour > from.hour ||
            (now.hour == from.hour && now.minute >= from.minute)) ||
        (now.hour < to.hour ||
            (now.hour == to.hour && now.minute <= to.minute));
  }
}
