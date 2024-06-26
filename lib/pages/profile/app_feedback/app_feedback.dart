import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../constant/constant.dart';
import '../../../controller/profileController.dart';

class AppFeedBack extends StatefulWidget {
  const AppFeedBack({super.key, this.id});

  final id;

  @override
  State<AppFeedBack> createState() => _AppFeedBackState();
}

class _AppFeedBackState extends State<AppFeedBack> {
  bool ratingBad = false;
  bool ratingAverage = false;
  bool ratingExcellent = false;
  String status = '';

  TextEditingController remark = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ProfileController>(context,);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: shadeOne,
            )),
        backgroundColor: darkShade,
        title: Text(
          "Feedback",
          style: TextStyle(color: shadeOne),
        ),
        // centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(
                  height: 80.h,
                ),
                Text("We value your opinions ",
                    style: TextStyle(fontSize: 24.sp)),
                SizedBox(
                  height: 24,
                ),
                Container(
                    width: 304.w,
                    child: Text(
                      "Your feedback on your stay experience \nwill be pivotal in elevating our \nservice to new heights.",
                      style: TextStyle(fontSize: 16.sp),
                      textAlign: TextAlign.center,
                    )),
                SizedBox(
                  height: 40.h,
                ),
                Container(
                  width: 150.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            ratingBad = !ratingBad;
                            ratingAverage = false;
                            ratingExcellent = false;
                            setState(() {
                              ratingBad ? status = "Bad" : status = "";
                            });
                          },
                          child: ratingBad == true
                              ? SvgPicture.asset(
                              "assets/svgImage/RatingBad.svg")
                              : SvgPicture.asset(
                              "assets/svgImage/SmileySad.svg")),
                      GestureDetector(
                          onTap: () {
                            ratingAverage = !ratingAverage;
                            ratingBad = false;
                            ratingExcellent = false;
                            setState(() {
                              ratingAverage ? status = "Average" : status = "";
                            });
                          },
                          child: ratingAverage == true
                              ? SvgPicture.asset(
                              "assets/svgImage/RatingAverage.svg")
                              : SvgPicture.asset(
                              "assets/svgImage/SmileyMeh.svg")),
                      GestureDetector(
                          onTap: () {
                            ratingExcellent = !ratingExcellent;
                            ratingAverage = false;
                            ratingBad = false;
                            setState(() {
                              ratingExcellent ? status = "Good" : status = "";
                            });
                          },
                          child: ratingExcellent == true
                              ? SvgPicture.asset(
                              "assets/svgImage/RatingExcellent.svg")
                              : SvgPicture.asset("assets/svgImage/Smiley.svg")),
                    ],
                  ),
                ),
                Text(
                  "$status",
                  style: TextStyle(fontSize: 12.sp),
                ),
                SizedBox(
                  height: 40.h,
                ),
                // if (ratingBad == true ||
                //     ratingAverage == true ||
                //     ratingExcellent == true)
                  Container(
                    height: 208.h,
                    width: 304.w,
                    decoration:
                    BoxDecoration(border: Border.all(color: goldShade)),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.sp, right: 10.sp),
                      child: TextField(
                        controller: remark,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1000),
                        ],
                        // maxLength: 5,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText:
                          "What can we do to improve your \nexperience ? ",
                          hintStyle:
                          TextStyle(color: shadeFive, fontSize: 16.sp),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        cursorColor: Colors.grey,
                        maxLines: null,
                        // Allow text to wrap to the next line
                        onChanged: (val) {},
                      ),
                    ),
                  ),
                SizedBox(
                  height: 24.h,
                ),
                SizedBox(
                  height: 56.h,
                  width: 304.w,
                  child: ElevatedButton(
                    onPressed: ratingAverage != false ||
                        ratingBad != false ||
                        ratingExcellent != false
                        ? () {
                      var data = {
                        "feedback": remark.text,
                        "rating": status
                      };
                      Provider.of<ProfileController>(context, listen: false).appFeedback(context, data);
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.black, backgroundColor: goldShade,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 24.h,
                ),
                // TextButton(
                //     onPressed: () {
                //       Navigator.pop(context);
                //     },
                //     child: Text(
                //       "Cancel",
                //       style: TextStyle(color: Colors.black),
                //     ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
