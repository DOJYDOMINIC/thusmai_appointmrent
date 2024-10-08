import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/pages/login_register_otp/login.dart';
import '../../constant/constant.dart';
import 'package:http/http.dart' as http;

import '../../controller/login_register_otp_api.dart';


class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key, this.data}) : super(key: key);
final data;

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  late String _newPassword;






  @override
  Widget build(BuildContext context) {

    // Get the height of the status bar
    final statusBarHeight = MediaQuery.of(context).padding.top;

    // Get the height of the bottom navigation bar (if present)
    final bottomNavBarHeight = MediaQuery.of(context).padding.bottom;

    final screen = MediaQuery.of(context).size.height -
        statusBarHeight +
        bottomNavBarHeight;
    // Initialize ScreenUtil
    ScreenUtil.init(context, designSize: Size(400, 880));

    return GestureDetector(
      onTap: () {
        if (!FocusScope.of(context).hasPrimaryFocus) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Form(
              key: _formKey,
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
                    height: MediaQuery.of(context).size.height,
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
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.sp, right: 10.sp),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Row(
                                children: [
                                  IconButton(onPressed: (){
                                    // Navigator.pop(context);
                                    Navigator.of(context).popUntil((route) => route.isFirst);

                                  }, icon: Icon(Icons.arrow_back_ios,color: Colors.white)),
                                  SizedBox(width: 20.w,),
                                  Text("Reset Password",style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 16),),
                                ],
                              ),
                              Image(
                                height: 48.h,
                                image: const AssetImage(logo),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Expanded(child: Text("Your identity has been verified. Set your new password.",style:TextStyle(fontSize: 14.sp,color: Colors.white),)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 350.h,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 8) {
                                return 'Password must be at least 8 characters long';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _newPassword = value;
                              });
                            },
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            cursorColor: Colors.white,
                            obscureText: !_isNewPasswordVisible,
                            decoration: InputDecoration(
                              hintText: "Password",
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: goldShade,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isNewPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: goldShade,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isNewPasswordVisible = !_isNewPasswordVisible; // Toggle password visibility
                                  });
                                },
                              ),
                              fillColor: darkShade,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    BorderSide(color: goldShade, width: 1),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    BorderSide(color: goldShade, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    BorderSide(color: goldShade, width: 1),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value != _newPassword) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                            ),
                            cursorColor: Colors.white,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              hintText: "Confirm Password",
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: goldShade,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: goldShade,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              fillColor: darkShade,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                borderSide:
                                    BorderSide(color: goldShade, width: 1),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                borderSide:
                                    BorderSide(color: goldShade, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                borderSide:
                                    BorderSide(color: goldShade, width: 1),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40.h,
                          ),
                          SizedBox(
                            height: 56.h,
                            width: 304.w,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  print(widget.data.toString());
                                  var data = {
                                    "email":  widget.data["email"].toString(),
                                    "new_password": _newPassword.trim(),
                                  };
                                  Provider.of<AppLogin>(context, listen: false).resetPassword(context,data);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shadowColor: Colors.black, backgroundColor: goldShade,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Reset Password",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
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
        ),
      ),
    );
  }
}
