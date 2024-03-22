import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thusmai_appointmrent/pages/login_register_otp/login.dart';
import '../../constant/constant.dart';
import '../../controller/login_register_otp_api.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil. init(context, designSize: const Size(400, 880));
    var pro = Provider.of<AppLogin>(context);

    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: profileBackground,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: pageBackground,
            )),
        backgroundColor: appbar,
        title: Text(
          profile,
          style: TextStyle(color: pageBackground),
        ),
        // centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Container(
              height: 192.h,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: pageBackground,
                  borderRadius: BorderRadius.circular(16.sp)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: pro.userData == null
                    ? Center(child: CircularProgressIndicator())
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${pro.userData?.firstName ?? ""} ${pro.userData?.lastName ?? ""}",style: TextStyle(fontSize: 22.sp),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "Card no : ${pro.userData?.uId ?? ""}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  pro.userData?.phone ?? "",
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  pro.userData?.email ?? "",
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "DOJ : ${pro.userData?.doj.toString().split(" ").first}",
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 48.sp,
                                backgroundColor: buttonColor,
                                child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 45.sp,
                                    backgroundImage:
                                        // defaultImage == null ?
                                        MemoryImage(
                                      base64Decode(defaultImage),
                                    )
                                    // : Image.file(File(_image!.path)).image
                                    // const AssetImage(
                                    //             "assets/images/man.png") as ImageProvider<Object>?
                                    ),
                              ),
                              Text(
                                  "Valid : ${pro.userData?.expiredDate.toString().split(" ").first ?? ""}",),
                            ],
                          )
                        ],
                      ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.sp, 0.sp, 16.sp, 0.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 112.h,
                    decoration: BoxDecoration(
                      color: rewardRefer,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0,
                              5), // Positive vertical offset for bottom shadow
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/svgImage/Gift.svg",
                          color: inputText,
                          width: 40.w,
                          height: 40.h,
                        ),
                        Text(
                          "Reward",
                          style: TextStyle(fontSize: 22),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 16.w,
                ),
                Expanded(
                  child: Container(
                    height: 112.h,
                    decoration: BoxDecoration(
                      color: rewardRefer,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0,
                              5), // Positive vertical offset for bottom shadow
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/svgImage/Megaphone.svg",
                          color: inputText,
                          width: 40.w,
                          height: 40.h,
                        ),
                        Text(
                          "Refer",
                          style: TextStyle(fontSize: 22),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.sp, 16.sp, 16.sp, 16.sp),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.sp),
                    color: pageBackground),
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
                                color: inputText,
                                fontWeight: FontWeight.w500),
                          ),
                          Divider(
                            thickness: 2,
                            color: inputText,
                          ),
                          Container(
                            height: 48.sp,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.account_circle_outlined),
                                    SizedBox(width: 16.sp,),
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
                          Divider(),
                          Container(
                            height: 48.sp,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.account_balance),
                                    SizedBox(width: 16.sp,),
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
                          Divider(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.sp, 0.sp, 16.sp, 16.sp),
                      child: GestureDetector(
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.clear();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ));
                          },
                          child: Container(
                              height: 56.h,
                              width: width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: inputText)),
                              child: Center(
                                  child: Text(
                                "Logout",
                                style: TextStyle(color: buttonColor),
                              )))),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
