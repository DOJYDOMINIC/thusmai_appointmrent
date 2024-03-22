import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';

import '../../controller/login_register_otp_api.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  @override
  void initState() {
    super.initState();
    Provider.of<AppLogin>(context, listen: false).getUserByID(context);
  }

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<AppLogin>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.sp, right: 16.sp),
              child: Container(
                height: 192.h,
                decoration: BoxDecoration(
                    border: Border.fromBorderSide(BorderSide.none),
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/images/overviewimg1.jpg")),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.red),
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
                    padding: EdgeInsets.fromLTRB(16.sp, 16.sp, 32.sp, 16.sp),
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
                                  "${pro.userData?.firstName} ${pro.userData?.lastName}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "Card No : ${pro.userData?.uId}",
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
                              "DOJ : ${pro.userData?.doj}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 12.sp),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              "VALID : ${pro.userData?.expiredDate}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 12.sp),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Container(
                height: 192.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Adjust shadow color and opacity as needed
                      offset: Offset(1, 0), // Offset to bottom
                      blurRadius: 6, // Adjust the blur radius
                      spreadRadius: 5, // Adjust the spread radius
                    ),
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2), // Adjust shadow color and opacity as needed
                      offset: Offset(-1, 0), // Offset to left
                      blurRadius: 6, // Adjust the blur radius
                      spreadRadius: 5, // Adjust the spread radius
                    ),
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2), // Adjust shadow color and opacity as needed
                      offset: Offset(1, 0), // Offset to right
                      blurRadius: 6, // Adjust the blur radius
                      spreadRadius: 5, // Adjust the spread radius
                    ),
                  ],
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
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
