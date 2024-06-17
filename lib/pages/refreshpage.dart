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
          OutlinedButton(onPressed: onTap, child: Text("Refresh",style: TextStyle(color: Colors.black),))
        ],
      ),
    );
  }
}
