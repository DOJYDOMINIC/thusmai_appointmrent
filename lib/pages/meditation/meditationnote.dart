import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constant/constant.dart';
import '../../controller/login_register_otp_api.dart';
import '../../controller/meditationController.dart';
import '../../tabs/messsagetab.dart';
import '../../widgets/additionnalwidget.dart';
import '../profile/profile.dart';

class MeditationNote extends StatefulWidget {
  const MeditationNote({super.key});

  @override
  State<MeditationNote> createState() => _MeditationNoteState();
}

class _MeditationNoteState extends State<MeditationNote> {
  TextEditingController noteController = TextEditingController();

  bool _global = false;

  @override
  Widget build(BuildContext context) {
    var meditation = Provider.of<MeditationController>(context);

    var pro = Provider.of<AppLogin>(context);
    return Scaffold(
      backgroundColor: shadeOne,
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
          "Notes",
          style: TextStyle(color: shadeOne),
        ),
        // centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 180.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    goldShade.withOpacity(.8), // Lighter color
                    goldShade.withOpacity(.5), // Lighter color
                    goldShade.withOpacity(.3), // Lighter color
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.self_improvement,
                        color: darkShade,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Start your meditation",
                        style: TextStyle(
                          color: darkShade,
                          fontSize: 20.sp,
                        ),
                      ),
                    ],
                  ),
                  spaceBetween,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("cycle"),
                      Text("   : ${pro.userData?.cycle ?? 0}"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Day  "),
                      Text("    : ${pro.userData?.day ?? 0}"),
                    ],
                  ),
                ],
              ),
            ),
            spaceBetween,
            Text(
              "Share your experience",
              style: TextStyle(fontSize: 24.sp),
            ),
            spaceBetween,
            Container(
                width: 304,
                child: Text(
                  "Remember that meditation is a skill that \ndevelops over time, so be patient with \nyourself and embrace the learning \nprocess",
                  textAlign: TextAlign.center,
                )),
            spaceBetween,
            Container(
              height: 168.h,
              width: 368.w,
              decoration: BoxDecoration(border: Border.all(color: goldShade)),
              child: Padding(
                padding: EdgeInsets.only(left: 10.sp, right: 10.sp),
                child: TextField(
                  controller: noteController,
                  // inputFormatters: [
                  //   LengthLimitingTextInputFormatter(1000),
                  // ],
                  // maxLength: 5,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: "Note... ",
                    hintStyle: TextStyle(color: shadeFive, fontSize: 16.sp),
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
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Send :"),
                  Checkbox(
                      side: BorderSide(color: shadeNine, width: 2),
                      activeColor: brown,
                      value: _global,
                      onChanged: (val) {
                        setState(() {
                          _global = !_global;
                        });
                      }),
                  Text("Global"),
                ],
              ),
            ),
            SizedBox(
              height: 50.h,
            ),
            SizedBox(
              height: 56.h,
              width: 304.w,
              child: ElevatedButton(
                onPressed: () {
                  if (noteController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text("Please Fill Note"),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  } else {
                    DateTime now = DateTime.now();
                    String formattedTime = DateFormat('h:mm a').format(now);
                    String messageTDate =
                        DateFormat('MMMM dd, yyyy').format(DateTime.now());
                    meditation.meditationNote(
                        context,
                        "Meditation Note : ${noteController.text}",
                        _global ? "global" : "private",
                        formattedTime,
                        messageTDate);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.black,
                  backgroundColor: goldShade,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.send,
                      color: darkShade,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      "Send",
                      style: TextStyle(color: darkShade),
                    ),
                  ],
                ),
              ),
            ),
            spaceBetween,
          ],
        ),
      ),
    );
  }
}
