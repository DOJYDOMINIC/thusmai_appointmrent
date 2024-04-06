import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';
import 'package:thusmai_appointmrent/controller/payment_controller.dart';
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
    Provider.of<AppLogin>(context, listen: false).getUserByID();
  }
  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<AppLogin>(context);
    String? firstName = pro.userData?.firstName; // Get the first name, if available
    String? lastName = pro.userData?.lastName; // Get the last name, if available
    String capitalizedFirstName = firstName != null ? firstName[0].toUpperCase() + firstName.substring(1) : ""; // Capitalize the first letter of first name if not null
    String capitalizedLastName = lastName != null ? lastName[0].toUpperCase() + lastName.substring(1) : ""; // Capitalize the first letter of last name if not null
    return Scaffold(
      backgroundColor: shadeOne,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: (){
                  Provider.of<PaymentController>(context, listen: false).paymentStatus(context,pro.userData?.uId);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 16.sp, right: 16.sp,top: 16.sp),
                  child: Container(
                    height: 192.h,
                    decoration: BoxDecoration(
                        border: Border.fromBorderSide(BorderSide.none),
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage("assets/images/overviewimg1.jpg")),
                        borderRadius: BorderRadius.circular(12),),
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
                                    Text("${capitalizedFirstName}  ${capitalizedLastName}",
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
                                  "DOJ : ${pro.userData?.doj != null ? DateFormat('dd/MM/yyyy').format(pro.userData!.doj!) : 'N/A'}",

                                  style: TextStyle(
                                      fontWeight: FontWeight.w500, fontSize: 12.sp),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  "VALID :  ${pro.userData?.expiredDate != null ? DateFormat('dd/MM/yyyy').format(pro.userData!.expiredDate!) : 'N/A'}",
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
              ),
              spaceBetween,
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Container(
                  height: 176.0,
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
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Meditation Cycle"),
                        spaceBetween,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.self_improvement,size: 80.sp,),
                            Container(height: 104.h,width: 1,color: brown,),
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
                                Text("${pro.userData?.cycle??0}"),
                                spaceBetween,
                                Text("${pro.userData?.cycle??0}"),
                                spaceBetween,
                                Text("${pro.userData?.day??0}"),
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
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Container(
                  height: 176.0,
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
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              spaceBetween,
            ],
          ),
        ),
      ),
    );
  }
}
