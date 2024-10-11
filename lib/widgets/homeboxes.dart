import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/constant.dart';

class MeditationCard extends StatelessWidget {
  final VoidCallback onTap;
  //final int currentCycle;
  final int daysCompleted;
  final bool valueData;
  final String dataStringOne;
  final String dataStringTwo;
  final Color background;
  final String title;
  final IconData iconData;

  const MeditationCard(
      {Key? key,
      required this.onTap,
      //required this.currentCycle,
      required this.daysCompleted,
      required this.valueData,
      required this.dataStringOne,
      required this.dataStringTwo,
      required this.background,
      required this.title,
      required this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.sp),
        child: Container(
          height: 176.h,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(12.sp),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.sp, 8.sp, 16.sp, 8.sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 8.sp),
                Center(
                  child: Icon(
                    iconData,
                    size: 48.sp,
                  ),
                ),
                SizedBox(height: 8.sp),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Text(
                          //   dataStringOne,
                          //   style: TextStyle(fontSize: 12.sp),
                          //   textAlign: TextAlign.center,
                          // ),
                          Text(
                            dataStringTwo,
                            style: TextStyle(fontSize: 12.sp),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Spacer(),
                      if (valueData)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Text(
                            //   " : $currentCycle",
                            //   style: TextStyle(fontSize: 12.sp),
                            //   textAlign: TextAlign.center,
                            // ),
                            Text(
                              " : $daysCompleted",
                              style: TextStyle(fontSize: 12.sp),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
