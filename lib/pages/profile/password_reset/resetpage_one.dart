import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../constant/constant.dart';
import '../../../controller/login_register_otp_api.dart';

class ResetPageOne extends StatefulWidget {
  const ResetPageOne({super.key});

  @override
  State<ResetPageOne> createState() => _ResetPageOneState();
}

class _ResetPageOneState extends State<ResetPageOne> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
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
      body:SingleChildScrollView(
        child: Form(
          key: _formKey,
          child:Container(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 44,),
                    SvgPicture.asset(
                      "assets/svgImage/Reset password.svg",
                    ),
                    Text("For a verification code to be sent to the \nregistered mobile number, please provide your \nemail address.",textAlign: TextAlign.center,),
                    Column(
                      children: [
                        TextFormField(
                          controller: _email,
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
                          cursorColor: darkShade,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(15),
                            hintText: "Email",
                            hintStyle: TextStyle(
                              color: shadeTen,
                              fontWeight: FontWeight.normal,
                            ),
                            prefixIcon: Icon(
                              Icons.email_outlined,
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
                          height: 56.h,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Provider.of<AppLogin>(context, listen: false).requestPasswordReset(context,_email.text,);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.black,
                              elevation: 4,
                              primary: goldShade,
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
                    SizedBox(height: 100,)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

