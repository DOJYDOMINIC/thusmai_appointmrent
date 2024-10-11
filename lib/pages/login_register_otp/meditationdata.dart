import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/controller/login_register_otp_api.dart';

import '../../constant/constant.dart';
import '../../services/firebase_notification.dart';
import '../bottom_navbar.dart';

class MeditationData extends StatefulWidget {
  const MeditationData({Key? key}) : super(key: key);

  @override
  State<MeditationData> createState() => _MeditationDataState();
}

class _MeditationDataState extends State<MeditationData> {
  @override
  void initState() {
    super.initState();
    FirebaseApi().initNotifications();
    Provider.of<AppLogin>(context, listen: false).listQuestions();
    Provider.of<AppLogin>(context, listen: false).fetchReferralName();
  }

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<AppLogin>(context);
    var width = MediaQuery.of(context).size.width;
    // Get the height of the status bar
    final statusBarHeight = MediaQuery.of(context).padding.top;
    // Get the height of the bottom navigation bar (if present)
    final bottomNavBarHeight = MediaQuery.of(context).padding.bottom;
    final screen = MediaQuery.of(context).size.height -
        statusBarHeight +
        bottomNavBarHeight;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: screen,
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 570.h,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(guruji),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: screen,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(.5),
                        Colors.black.withOpacity(.5),
                        Colors.black.withOpacity(.5),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.sp, 0.sp, 16.sp, 0.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                  )),
                              Text(
                                "Meditation Data",
                                style: TextStyle(
                                    fontSize: 22.sp, color: Colors.white),
                              ),
                            ],
                          ),
                          Image(
                            height: 48.h,
                            image: const AssetImage(logo),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 56.h,
                          width: width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: goldShade),
                              color: darkShade),
                          child: Row(
                            children: [
                              Icon(
                                Icons.supervised_user_circle_outlined,
                                color: goldShade,
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Referral : ${Provider.of<AppLogin>(context).referralName}",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  )),
                            ],
                          )),
                    ),
                    SizedBox(height: 120.h),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.sp, 0.sp, 16.sp, 0.sp),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: goldShade),
                              color: darkShade.withOpacity(.75)),
                          child: Padding(
                            padding:
                                EdgeInsets.fromLTRB(16.sp, 16.sp, 16.sp, 0.sp),
                            child: Column(
                              children: [
                                Text(
                                  "${pro.listQuestion.question ?? "N/A"}",
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  height: 16.h,
                                ),
                                Text(
                                  "Please press and drag your opinion from the list below in an orderly manner.",
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  height: 16.h,
                                ),
                                Expanded(
                                  child: ReorderableListView(
                                    onReorder: pro.updateMyTile,
                                    children: [
                                      for (int i = 0;
                                          i < pro.myTiles.length;
                                          i++)
                                        Column(
                                          key: ValueKey(pro.myTiles[i]),
                                          children: [
                                            Container(
                                              color: darkShade.withOpacity(.75),
                                              child: ListTile(
                                                tileColor:
                                                    darkShade.withOpacity(.75),
                                                title: Row(
                                                  children: [
                                                    Text(
                                                      "0${i + 1} ",
                                                      style: TextStyle(
                                                          color: goldShade),
                                                    ),
                                                    Text(
                                                      "${pro.myTiles[i]}",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                                trailing: Icon(
                                                  Icons.drag_indicator,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              thickness: .3,
                                              height: .2,
                                              color:
                                                  goldShade, // Light color underline
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
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.sp, 56.sp, 0.sp, 56.sp),
                      child: SizedBox(
                        height: 56.h,
                        width: 304.w,
                        child: ElevatedButton(
                          onPressed: () {
                            pro.meditationData(context, pro.myTiles);
                            // print(pro.myTiles);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CustomBottomNavBar(),
                                ));
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
                              Text(
                                "Continue",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
