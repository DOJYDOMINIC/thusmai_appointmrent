import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thusmai_appointmrent/pages/login_register_otp/reset_password.dart';
import 'package:thusmai_appointmrent/widgets/additionnalwidget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constant/constant.dart';

import '../../controller/login_register_otp_api.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    Provider.of<AppLogin>(context, listen: false).listQuestions();
  }

  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = true;
  late String _email;
  late String _password;

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
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.sp, right: 10.sp),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30.h,
                          ),
                          Image(
                            height: 64.h,
                            image: const AssetImage(logo),
                          ),
                          SizedBox(
                            height: 300.h,
                          ),
                          Row(
                            children: [
                              Text("In stillness find the tranquil stream",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400)),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!EmailValidator.validate(value.trim())) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _email = value.replaceAll(' ', '').trim();
                            },
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                            ),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              hintText: "Email",
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                              prefixIcon: Icon(
                                Icons.mail_outline,
                                color: goldShade,
                              ),
                              fillColor: darkShade,
                              disabledBorder: InputBorder.none,
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                borderSide:
                                    BorderSide(color: goldShade, width: 1),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                borderSide:
                                    BorderSide(color: goldShade, width: 1),
                              ),
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
                            height: 20.h,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _password = value.trim();
                            },
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                            ),
                            cursorColor: Colors.white,
                            obscureText: _isPasswordVisible,
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
                                  _isPasswordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: goldShade,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible =
                                        !_isPasswordVisible; // Toggle password visibility
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
                                  // If the form is valid, save the form state
                                  _formKey.currentState!.save();
                                  // Here you can perform your login logic
                                  Map<String, dynamic> data = {
                                    "email": _email,
                                    "password": _password
                                  };
                                  Provider.of<AppLogin>(context, listen: false)
                                      .loginApi(context, data);
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
                                  Text(
                                    "Login",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            // physics: NeverScrollableScrollPhysics(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    slidePageRoute(context, Register());
                                    // Navigator.push(context,  MaterialPageRoute(builder:  (context) => Register(),));
                                  },
                                  child: Text(
                                    "Forgot Password.",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: goldShade,
                                      fontWeight: FontWeight.normal,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Don’t have an account?",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    launchURL(registerUrl);
                                  },
                                  child: Text(
                                    "Register",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: goldShade,
                                      fontWeight: FontWeight.normal,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
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
