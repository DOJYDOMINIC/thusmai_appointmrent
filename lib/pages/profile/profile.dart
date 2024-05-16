import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thusmai_appointmrent/pages/login_register_otp/login.dart';
import 'package:thusmai_appointmrent/pages/profile/edit/bank_detail_edit.dart';
import 'package:thusmai_appointmrent/pages/profile/password_reset/resetpage_one.dart';
import 'package:thusmai_appointmrent/pages/profile/edit/profile_edit.dart';
import 'package:thusmai_appointmrent/pages/profile/referpage.dart';
import 'package:thusmai_appointmrent/pages/profile/rewardpage.dart';
import '../../constant/constant.dart';
import '../../controller/login_register_otp_api.dart';
import '../../controller/profileController.dart';
import '../../widgets/additionnalwidget.dart';
import 'app_feedback/app_feedback.dart';
import 'edit/bank_info.dart';
import 'edit/personalInfo.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  initState() {
    super.initState();
    Provider.of<ProfileController>(context,listen: false).getBankDetails();
  }
  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<AppLogin>(context);

    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: shadeThree,
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
          profile,
          style: TextStyle(color: shadeOne),
        ),
        // centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Container(
                  height: 192.h,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: shadeOne, borderRadius: BorderRadius.circular(16.sp)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: pro.userData == null
                        ? Center(child: CircularProgressIndicator())
                        :profileCard(context),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.sp, 0.sp, 16.sp, 0.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      referReward(gift,"Reward",(){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RewardPage(),));
                      }),
                    SizedBox(
                      width: 16.w,
                    ),
                    referReward(megaphone,"Refer",(){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ReferPage(),));
        
                    }),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.sp, 16.sp, 16.sp, 16.sp),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.sp),
                      color: shadeOne),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.sp, 16.sp, 16.sp, 0.sp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "User details",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: darkShade,
                                  fontWeight: FontWeight.w500),
                            ),
                            Divider(
                              thickness: 2,
                              color: darkShade,
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalInfo(),));
                              },
                              child: Container(
                                height: 48.h,
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.account_circle_outlined),
                                        SizedBox(
                                          width: 16.sp,
                                        ),
                                        Text("Personal info",
                                            style: TextStyle(fontSize: 16.sp)),
                                      ],
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 22.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => BankDetails(),));

                              },
                              child: Container(
                                height: 48.h,
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.account_balance),
                                        SizedBox(
                                          width: 16.sp,
                                        ),
                                        Text("Bank info",
                                            style: TextStyle(fontSize: 16.sp)),
                                      ],
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 22.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPageOne(),));
                              },
                              child: Container(
                                height: 48.h,
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.lock_reset),
                                        SizedBox(
                                          width: 16.sp,
                                        ),
                                        Text("Reset password",
                                            style: TextStyle(fontSize: 16.sp)),
                                      ],
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 22.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AppFeedBack(),));
        
                              },
                              child: Container(
                                height: 48.h,
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.feedback),
                                        SizedBox(
                                          width: 16.sp,
                                        ),
                                        Text("Feedback",
                                            style: TextStyle(fontSize: 16.sp)),
                                      ],
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 22.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.sp, 0.sp, 16.sp, 16.sp),
                        child: GestureDetector(
                          onTap: () async {
                            // Clear SharedPreferences
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.clear();
                            // Navigate to the login page and replace the current page
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(),
                              ),
                            );
                          },
                          child: Container(
                            height: 56.h,
                            width: width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: darkShade),
                            ),
                            child: Center(
                              child: Text(
                                "Logout",
                                style: TextStyle(color: goldShade),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
