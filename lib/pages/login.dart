import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/appointment_constant.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {

    // Get the height of the status bar
    final statusBarHeight = MediaQuery.of(context).padding.top;

    // Get the height of the bottom navigation bar (if present)
    final bottomNavBarHeight = MediaQuery.of(context).padding.bottom;

    final  screen = MediaQuery.of(context).size.height - statusBarHeight +bottomNavBarHeight;
    // Initialize ScreenUtil
    ScreenUtil.init(context, designSize: Size(375, 812));

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
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
              Container(
                height: screen,
                child: Padding(
                  padding:  EdgeInsets.only(left: 10.sp,right: 10.sp),
                  child: Column(
                    children: [
                      SizedBox(height: 50,),
                      Image(
                        height: 64.h,
                        image: AssetImage(logo),
                      ),
                      SizedBox(height: 350,),
                      SizedBox(
                        height: 56.h,
                        child: TextFormField(
                          style: TextStyle(
                              color: Colors.white, fontSize: 16.sp),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.normal),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.mail_outline, color: buttonColor),
                            ),
                            fillColor: appbar,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h,),
                      SizedBox(
                        height: 56.h,
                        child: TextFormField(
                          style: TextStyle(color: Colors.white, fontSize: 16.sp),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.normal),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.lock_outline, color: buttonColor),
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.visibility_off, color: buttonColor),
                            ),
                            fillColor: appbar,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50.h,),
                      SizedBox(
                        height: 56.h,
                        width: 304.w,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.black,
                            elevation: 4,
                            primary: buttonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Login",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h,),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics:NeverScrollableScrollPhysics(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Handle Forgot Password button tap
                              },
                              child: Text(
                                "Forgot Password.",
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    color: buttonColor,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                            Text(
                              " Don’t have an account?",
                              style: TextStyle(
                                  fontSize: 13.sp, color: Colors.white),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Handle SignUp button tap
                              },
                              child: Text(
                                " SignUp",
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    color: buttonColor,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h,),
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
