import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thusmai_appointmrent/pages/appointment_add.dart';


void showPlatformDialog(BuildContext context, String firstImage, String title, String body,String buttonText,Color color) {
  // var width = MediaQuery.of(context).size.width;
  if (Platform.isIOS) {
    // iOS dialog
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          // contentPadding: EdgeInsets.zero,
          content: Column(
            children: [
              Image.asset(
                firstImage,
                height: 100, // Adjust height as needed
                width:100, // Make image take full width
                fit: BoxFit.cover, // Fill the space
              ),
              SizedBox(height: 8),
              Text(title),
              Text(body),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                // Perform OK action
              },
            ),
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {

                Navigator.of(context).pop();
                // Perform cancel action
              },
            ),
          ],
        );
      },
    );
  } else if (Platform.isAndroid) {
    // Android dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var size = SizedBox(height: 24,);
        return AlertDialog(
          backgroundColor: Color.fromRGBO(255, 251, 255, 1),
          content: SizedBox(
            width: 200,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                size,
                Image.asset(
                  firstImage,
                  height: 100, // Adjust height as needed
                  width: 100, // Make image take full width
                  fit: BoxFit.cover, // Fill the space
                ),
                size,
                Text(title,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 24,),),
                SizedBox(height: 16,),
                Text(body,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 14,),),
                size,

                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if(buttonText == "Continue"){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AppointmentPage(),));
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
                // size,
                // if(body != "User not found")
                //   TextButton(
                //     child: const Text('OK'),
                //     onPressed: () {
                //       Navigator.of(context).pop();
                //       // Perform OK action
                //     },
                //   ),
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
