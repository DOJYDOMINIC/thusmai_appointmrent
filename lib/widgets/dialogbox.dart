import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constant/constant.dart';


void showPlatformDialog(BuildContext context, String firstImage, String title,
    String body, String buttonText, Color color) {
  // var width = MediaQuery.of(context).size.width;
  if (Platform.isIOS) {
    // iOS dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var size = SizedBox(height: 24);

        return CupertinoAlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              size,
              Image.asset(
                firstImage,
                height: 100.h, // Adjust height as needed
                width: 100.w, // Make image take full width
                fit: BoxFit.fill, // Fill the space
              ),
              size,
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 24),
              ),
              SizedBox(height: 16.h),
              Text(
                body,
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              size,
              SizedBox(
                height: 56.h,
                child: CupertinoButton(
                  onPressed: () {
                    if (buttonText == "Continue") {
                      Navigator.of(context).pop();
                    }
                    Navigator.of(context).pop();
                  },
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        buttonText,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                size,
                Image.asset(
                  firstImage,
                  height: 100.h, // Adjust height as needed
                  width: 100.w, // Make image take full width
                  fit: BoxFit.fill, // Fill the space
                ),
                size,
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 24,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  body,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                size,
                SizedBox(
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: () {
                      if (buttonText == "Continue") {
                        Navigator.of(context).pop();
                      }
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      // shadowColor: Colors.red, // Customize the shadow color
                      // elevation: 4, // Adjust the elevation for the shadow
                      // Customize the background color
                      primary: color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            16), // Adjust the radius as needed
                      ), // Example color, change it according to your preference
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          buttonText,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  } else {
    // Unsupported platform
    print('Unsupported platform');
  }
}
