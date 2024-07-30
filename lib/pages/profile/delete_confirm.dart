import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../constant/constant.dart';
import '../../controller/login_register_otp_api.dart';

class DeleteConfermation extends StatefulWidget {
  const DeleteConfermation({super.key});

  @override
  State<DeleteConfermation> createState() => _DeleteConfermationState();
}

class _DeleteConfermationState extends State<DeleteConfermation> {
  @override
  void initState() {
    super.initState();
    Provider.of<AppLogin>(context, listen: false).getUserByID();

  }

  // bool ratingBad = false;
  // bool ratingAverage = false;
  // bool ratingExcellent = false;
  String _phone = '';
  String _email = '';
  bool _isPasswordVisible = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<AppLogin>(context);
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
          "Delete Confirmation",
          style: TextStyle(color: shadeOne),
        ),
        // centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SvgPicture.asset(deleteForever),
                Text(
                  "For security purposes, please enter your Email id \nand phone number to confirm the \naccount deletion.",
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 36.h,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty || pro.userData?.email != value) {
                      return 'Please enter a valid Email';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _email = value.trim();
                  },
                  style: TextStyle(
                    color: darkShade,
                    fontSize: 16.sp,
                  ),
                  cursorColor: darkShade,
                  obscureText: _isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(
                      color: darkShade,
                      fontWeight: FontWeight.normal,
                    ),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: goldShade,
                    ),
                    fillColor: shadeFour,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: BorderSide(color: goldShade, width: 1),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: BorderSide(color: goldShade, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: BorderSide(color: goldShade, width: 1),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty || pro.userData?.phone != _phone) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _phone = value.trim();
                  },
                  style: TextStyle(
                    color: darkShade,
                    fontSize: 16.sp,
                  ),
                  cursorColor: darkShade,
                  obscureText: _isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "Phone",
                    hintStyle: TextStyle(
                      color: darkShade,
                      fontWeight: FontWeight.normal,
                    ),
                    prefixIcon: Icon(
                      Icons.phone,
                      color: goldShade,
                    ),
                    fillColor: shadeFour,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: BorderSide(color: goldShade, width: 1),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: BorderSide(color: goldShade, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: BorderSide(color: goldShade, width: 1),
                    ),
                  ),
                ),
                SizedBox(
                  height: 36.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 56.h,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              Provider.of<AppLogin>(context,listen: false).deleteUser(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.black,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: red),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Delete",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: SizedBox(
                        height: 56.h,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.black,
                            backgroundColor: red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Cancel",
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
