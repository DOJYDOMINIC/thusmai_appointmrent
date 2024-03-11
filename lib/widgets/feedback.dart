import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constant/constant.dart';

void feedBackDialog(BuildContext context,) {
  // var width = MediaQuery.of(context).size.width;
  TextEditingController remark = TextEditingController();
  if (Platform.isIOS) {
    // iOS dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var size = const SizedBox(height: 24);

        return CupertinoAlertDialog(
          // content: Column(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     size,
          //     Image.asset(
          //       imageString,
          //       height: 100.h, // Adjust height as needed
          //       width: 100.w, // Make image take full width
          //       fit: BoxFit.fill, // Fill the space
          //     ),
          //     size,
          //     Text(
          //       title,
          //       style: TextStyle(fontWeight: FontWeight.normal, fontSize: 24),
          //     ),
          //     SizedBox(height: 16.h),
          //     Text(
          //       body,
          //       style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
          //       textAlign: TextAlign.center,
          //     ),
          //     size,
          //     SizedBox(
          //       height: 56.h,
          //       child: CupertinoButton(
          //         onPressed: () {
          //           if (buttonText == "Continue") {
          //             Navigator.of(context).pop();
          //           }
          //           Navigator.of(context).pop();
          //         },
          //         color: color,
          //         borderRadius: BorderRadius.circular(16),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Text(
          //               buttonText,
          //               style: TextStyle(color: Colors.white),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        );
      },
    );
  } else if (Platform.isAndroid) {
    // Android dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var size = SizedBox(
          height: 24.h,
        );
        return AlertDialog(
          backgroundColor: pageBackground,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            // children: [
            //   size,
            //   Image.asset(
            //     imageString,
            //     height: 100.h, // Adjust height as needed
            //     width: 100.w, // Make image take full width
            //     fit: BoxFit.fill, // Fill the space
            //   ),
            //   size,
            //   Text(
            //     title,
            //     style: TextStyle(
            //       fontWeight: FontWeight.normal,
            //       fontSize: 24,
            //     ),
            //   ),
            //   SizedBox(
            //     height: 16,
            //   ),
            //   Text(
            //     body,
            //     style: TextStyle(
            //       fontWeight: FontWeight.normal,
            //       fontSize: 14,
            //     ),
            //     textAlign: TextAlign.center,
            //   ),
            //   size,
            //   SizedBox(
            //     height: 56.h,
            //     child: ElevatedButton(
            //       onPressed: () {
            //         if (buttonText == "Continue") {
            //           Navigator.of(context).pop();
            //         }
            //         Navigator.of(context).pop();
            //       },
            //       style: ElevatedButton.styleFrom(
            //         // shadowColor: Colors.red, // Customize the shadow color
            //         // elevation: 4, // Adjust the elevation for the shadow
            //         // Customize the background color
            //         primary: color,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(
            //               16), // Adjust the radius as needed
            //         ), // Example color, change it according to your preference
            //       ),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Text(
            //             buttonText,
            //             style: TextStyle(color: Colors.white),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ],
            children: [
              Text("We value your opinions ",style: TextStyle(fontSize: 20.sp)),
              Text("Your feedback on your stay experience will be pivotal in elevating our service to new heights.",style: TextStyle(fontSize: 14.sp),),
              Row(
                children: [
                  Text("Rate your experience :"),
                ],
              ),
              Container(
                height: 500,
                decoration: BoxDecoration(
                    border:
                    Border.all(color: Colors.grey.shade600),
                    ),
                padding: const EdgeInsets.only(left: 5),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: TextField(
                    controller: remark,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: "What can we do to improve your experience ? ",
                      hintStyle:
                      const TextStyle(color: Colors.grey,fontSize: 12),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    cursorColor: Colors.black,
                    maxLines: null,
                    // Allow text to wrap to the next line
                    onChanged: (val) {
                    },
                  ),
                ),
              ),

            ],
          ),
        );
      },
    );
  } else {
    // Unsupported platform
    print('Unsupported platform');
  }
}
