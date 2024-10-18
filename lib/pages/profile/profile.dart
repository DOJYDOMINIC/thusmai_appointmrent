import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thusmai_appointmrent/pages/profile/password_reset/resetpage_two.dart';
import 'package:thusmai_appointmrent/pages/profile/referpage.dart';
import 'package:thusmai_appointmrent/pages/profile/rewardpage.dart';
import '../../constant/constant.dart';
import '../../controller/login_register_otp_api.dart';
import '../../login/new_login.dart';
import '../../widgets/additionnalwidget.dart';
import 'app_feedback/app_feedback.dart';
import 'delete_account.dart';
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
    Provider.of<AppLogin>(context, listen: false).getUserByID();
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
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: shadeOne,
                      borderRadius: BorderRadius.circular(16.sp)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: pro.userData == null
                        ? Center(child: CircularProgressIndicator())
                        : profileCard(context),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.sp, 0.sp, 16.sp, 0.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    referReward(gift, "Reward", () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RewardPage(),
                          ));
                    }),
                    SizedBox(
                      width: 16.w,
                    ),
                    referReward(megaphone, "Refer", () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReferPage(),
                          ));
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
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PersonalInfo(),
                                    ));
                              },
                              child: Container(
                                height: 48.h,
                                color: shadeOne,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.account_circle_outlined),
                                        SizedBox(
                                          width: 16.sp,
                                        ),
                                        Text(personalInfo,
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
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BankDetails(),
                                    ));
                              },
                              child: Container(
                                height: 48.h,
                                color: shadeOne,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.account_balance),
                                        SizedBox(
                                          width: 16.sp,
                                        ),
                                        Text(bankInfo,
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
                            // GestureDetector(
                            //   onTap: () {
                            //     Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //           builder: (context) => ResetPageTwo(),
                            //         ));
                            //   },
                            //   child: Container(
                            //     height: 48.h,
                            //     color: shadeOne,
                            //     child: Row(
                            //       mainAxisAlignment:
                            //           MainAxisAlignment.spaceBetween,
                            //       children: [
                            //         Row(
                            //           children: [
                            //             Icon(Icons.lock_reset),
                            //             SizedBox(
                            //               width: 16.sp,
                            //             ),
                            //             Text(resetPassword,
                            //                 style: TextStyle(fontSize: 16.sp)),
                            //           ],
                            //         ),
                            //         Icon(
                            //           Icons.chevron_right,
                            //           size: 22.sp,
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            // Divider(),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AppFeedBack(),
                                    ));
                              },
                              child: Container(
                                height: 48.h,
                                color: shadeOne,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.feedback),
                                        SizedBox(
                                          width: 16.sp,
                                        ),
                                        Text(feedback,
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
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DeleteAccount(),
                                    ));
                              },
                              child: Container(
                                height: 48.h,
                                color: shadeOne,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.delete_outline_outlined,
                                        ),
                                        SizedBox(
                                          width: 16.sp,
                                        ),
                                        Text(deleteAccount,
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
                              onTap: () {
                                launchURL(privacyPolicy);
                              },
                              child: Container(
                                height: 48.h,
                                color: shadeOne,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.privacy_tip_outlined),
                                        SizedBox(
                                          width: 16.sp,
                                        ),
                                        Text(privacyPolicyTxt,
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
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.sp, 0.sp, 16.sp, 8.sp),
                        child: GestureDetector(
                          onTap: () async {
                            // Show customized confirmation dialog
                            bool? confirmLogout = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.warning_amber_rounded,
                                          size: 48,
                                          color: Colors.orangeAccent,
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          "Confirm Logout",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          "Are you sure you want to log out?",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        SizedBox(height: 24),
                                        Column(
                                          children: [
                                            // Cancel Button
                                            SizedBox(
                                              width: 272,
                                              height: 50,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color(0xFF516440),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            SizedBox(
                                              width: 272,
                                              height: 50,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(true);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  // backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    side: BorderSide(
                                                        color: Colors.red,
                                                        width: 1),
                                                  ),
                                                ),
                                                child: Text(
                                                  "Logout",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );

                            // If confirmed, perform logout
                            if (confirmLogout == true) {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.clear();
                              Provider.of<AppLogin>(context, listen: false)
                                  .backendSessionClear();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginUpdate()),
                                (Route<dynamic> route) => false,
                              );
                            }
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
                                logout,
                                style: TextStyle(color: goldShade),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
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
