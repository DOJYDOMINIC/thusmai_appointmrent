import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:thusmai_appointmrent/models/appointment_model.dart';
import 'dart:io';
import '../../constant/constant.dart';

class AppointmentShare extends StatefulWidget {
  const AppointmentShare({super.key, required this. appointment});
final ListElement appointment;
  @override
  State<AppointmentShare> createState() => _AppointmentShareState();
}

class _AppointmentShareState extends State<AppointmentShare> {
final _screenShotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
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
          "Appointment details",
          style: TextStyle(color: shadeOne),
        ),
        // centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 50,),
          Screenshot(
            controller: _screenShotController,
            child: Stack(
                children: [
                  Padding(
                    padding:  EdgeInsets.only(top: 40.sp),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 424,
                        width: 304,
                        decoration: BoxDecoration(
                          color: shadeSeven,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black)),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(height: 20,),
                                Column(
                                  children: [
                                    Text("${widget.appointment.userName??"N/A"}"),
                                    Text("${widget.appointment.uId??"N/A"}"),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex:10,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Appointment Id ",style: TextStyle(fontSize: 16.sp)),
                                          Text("App. Date ",style: TextStyle(fontSize: 16.sp)),
                                          Text("No. of days ",style: TextStyle(fontSize: 16.sp)),
                                          Text("No. of poeple ",style: TextStyle(fontSize: 16.sp)),
                                          Text("Pick up point ",style: TextStyle(fontSize: 16.sp)),
                                          Text("Contact ",style: TextStyle(fontSize: 16.sp)),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      flex:10,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(":  ${widget.appointment.id??"N/A"}",style: TextStyle(fontSize: 16.sp)),
                                          Text(":  ${widget.appointment.appointmentDate??"N/A"}",style: TextStyle(fontSize: 16.sp)),
                                          Text(":  ${widget.appointment.days??"N/A"}",style: TextStyle(fontSize: 16.sp)),
                                          Text(":  ${widget.appointment.numOfPeople??"N/A"}",style: TextStyle(fontSize: 16.sp)),
                                          Text(":  ${widget.appointment.from??"N/A"}",style: TextStyle(fontSize: 16.sp)),
                                          Text(":  ${widget.appointment.phone??"N/A"}",style: TextStyle(fontSize: 16.sp)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Contact us",style: TextStyle(fontSize: 12.sp)),
                                    SizedBox(height: 10,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.mail,size:16.sp,),
                                            Text("info@Thasmai.org.in",style: TextStyle(fontSize: 12.sp),),
                                          ],
                                        ),
                                        Container(
                                          height: 20.h,
                                          width: .8,
                                          color: darkShade,
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.call,size:16.sp,),
                                                Text("+91 89283 50018",style: TextStyle(fontSize: 12.sp),),

                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.call,size:16.sp,),
                                                Text("+91 88920 55550",style: TextStyle(fontSize: 12.sp),),

                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset(logo,width: 64)),
            ]),
          ),
          SizedBox(height: 20,),
          SizedBox(
            height: 56.h,
            width: 304.w,
            child: ElevatedButton(
              onPressed: () {
                _takeScreenShort();
              },
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.black,
                primary: goldShade,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.share,color: darkShade,),
                  SizedBox(width: 10,),
                  Text(
                    "Share",
                    style: TextStyle(color:darkShade),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 50,),
        ],
      ),
    );
  }

Future<void> _takeScreenShort() async {
  try {
    // Capture the screenshot
    Uint8List? imageFile = await _screenShotController.capture();
    if (imageFile == null) {
      throw Exception('Failed to capture screenshot');
    }

    // Get the temporary directory
    final directory = await getTemporaryDirectory();

    // Create a file path
    final filePath = '${directory.path}/${DateTime.now().toString()}.png';

    // Save the image to the file
    final file = File(filePath);
    await file.writeAsBytes(imageFile);

    // Share the file
    Share.shareXFiles([XFile(filePath)]);
  } catch (e) {
    print('Error taking screenshot: $e');
  }
}

}
