import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';


class RefreshPage extends StatelessWidget {
  final VoidCallback? onTap;
  const RefreshPage({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: SvgPicture.asset(errorSvg)),
          Padding(
            padding: EdgeInsets.fromLTRB(0.sp, 16.sp, 0.sp, 16.sp),
            child: Text(
              "Something went wrong.",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            width: 118.w,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.fromLTRB(16.sp, 8.sp, 16.sp, 8.sp),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.autorenew,
                      size: 18.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "Refresh",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
