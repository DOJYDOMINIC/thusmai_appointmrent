import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../constant/constant.dart';
import '../../../controller/login_register_otp_api.dart';

class ResetPageThree extends StatefulWidget {
  const ResetPageThree({super.key, this.data});

  final data;
  @override
  State<ResetPageThree> createState() => _ResetPageThreeState();
}

class _ResetPageThreeState extends State<ResetPageThree> {


  TextEditingController _newPassword = TextEditingController();

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
          "Reset password",
          style: TextStyle(color: shadeOne),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.center,
            child: Container(
              height: MediaQuery.of(context).size.height-100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(height: 44,),
                  SvgPicture.asset(
                    "assets/svgImage/Reset password.svg",
                  ),
                  Text("For a verification code to be sent to the \nregistered mobile number, please provide your \nemail address.",textAlign: TextAlign.center,),
                  Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          // _password = value;
                        },
                        style: TextStyle(
                          color: darkShade,
                          fontSize: 16.sp,
                        ),
                        controller: _newPassword,
                        cursorColor: darkShade,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(15),
                          hintText: "Password",
                          hintStyle: TextStyle(
                            color: shadeTen,
                            fontWeight: FontWeight.normal,
                          ),
                          prefixIcon: Icon(
                            Icons.key,
                            color: shadeTen,
                          ),
                          fillColor: shadeFour,
                          filled: true,
                          enabledBorder:OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(color: shadeTen,width: 1),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(color: shadeTen,width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(color: shadeTen,width: 1),
                          ),
                        ),
                      ),
                      SizedBox(height: 44.h),
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            var data = {
                              "email":  widget.data["email"].toString(),
                              "new_password": _newPassword.text,
                            };

                            Provider.of<AppLogin>(context, listen: false).resetPassword(context, data);
                          },
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.black, backgroundColor: goldShade, // Use primary instead of backgroundColor
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "send",
                                style: TextStyle(color: darkShade),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

