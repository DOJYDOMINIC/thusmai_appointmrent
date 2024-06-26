import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../../../constant/constant.dart';
import '../../../controller/login_register_otp_api.dart';
import 'dart:async';

class ResetPageTwo extends StatefulWidget {
  const ResetPageTwo({super.key, this.data,});

  final data;
  @override
  State<ResetPageTwo> createState() => _ResetPageTwoState();
}

class _ResetPageTwoState extends State<ResetPageTwo> {

  final _formKey = GlobalKey<FormState>();
  int secondsRemaining = 30;
  bool enableResend = false;
  late Timer timer;
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  var otpNumber;
  var focusedBorderColor = goldShade;
  var fillColor = darkShade;
  var borderColor = goldShade;
  @override
  initState() {
    super.initState();
    // Provider.of<AppLogin>(context, listen: false).getUserByID();
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
    // Provider.of<AppLogin>(context, listen: false).requestPasswordReset();
  }

  void _resendCode() {
    //other code here
    setState(() {
      secondsRemaining = 30;
      enableResend = false;
    });
  }
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  // TextEditingController _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<AppLogin>(context);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );

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
        physics: ClampingScrollPhysics(),
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
                    SizedBox(height: 44.h,),
                    SvgPicture.asset(
                      "assets/svgImage/Frame 2608318.svg",
                    ),
                    // Text("Enter the four digit code we sent to +91******5798",textAlign: TextAlign.center,),
                    Text("",style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                    Column(
                      children: [
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Pinput(
                            controller: pinController,
                            focusNode: focusNode,
                            // androidSmsAutofillMethod:
                            // AndroidSmsAutofillMethod.smsUserConsentApi,
                            // listenForMultipleSmsOnAndroid: true,
                            defaultPinTheme: defaultPinTheme,
                            separatorBuilder: (index) => const SizedBox(width: 8),
                            disabledPinTheme: defaultPinTheme.copyWith(
                              textStyle:
                              TextStyle(color: Colors.white, fontSize: 24),
                              decoration: defaultPinTheme.decoration!.copyWith(
                                borderRadius: BorderRadius.circular(
                                    8), // Set border radius here
                              ),
                            ),
                            onClipboardFound: (value) {
                              debugPrint('onClipboardFound: $value');
                              pinController.setText(value);
                            },
                            hapticFeedbackType: HapticFeedbackType.lightImpact,
                            onCompleted: (pin) {
                              otpNumber = pin;
                              // otpVerification();
                              debugPrint('onCompleted: $pin');
                            },
                            onChanged: (value) {
                              debugPrint('onChanged: $value');
                              otpNumber = value;
                            },
                            cursor: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 9),
                                  width: 22,
                                  height: 1,
                                  color: focusedBorderColor,
                                ),
                              ],
                            ),
                            focusedPinTheme: defaultPinTheme.copyWith(
                              textStyle:
                              TextStyle(color: Colors.white, fontSize: 24),
                              decoration: defaultPinTheme.decoration!.copyWith(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: focusedBorderColor, width: 2),
                              ),
                            ),

                            submittedPinTheme: defaultPinTheme.copyWith(
                              textStyle:
                              TextStyle(color: Colors.white, fontSize: 24),
                              decoration: defaultPinTheme.decoration!.copyWith(
                                color: fillColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: focusedBorderColor, width: 2),
                              ),
                            ),
                            enabled: true,
                            errorPinTheme: defaultPinTheme.copyBorderWith(
                              border: Border.all(color: Colors.redAccent),
                            ),
                          ),
                        ),

                        SizedBox(height: 44.h),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Text(
                        //       enableResend
                        //           ? 'Resend OTP in '
                        //           : 'Resend OTP in ',
                        //       style: TextStyle(color:darkShade, fontSize: 16.sp),
                        //     ),
                        //     Text(
                        //       enableResend
                        //           ? '00:30'
                        //           : '00:$secondsRemaining',
                        //       style: TextStyle(color: goldShade, fontSize: 16.sp),
                        //     ),
                        //   ],
                        // ),
                        SizedBox(height: 44.h),
                        SizedBox(
                          height: 56.h,
                          child: ElevatedButton(
                            onPressed: () {
                              Map<String, dynamic> data = {
                                "otp": otpNumber,
                                "email":pro.userData?.email,
                              };
                              if (_formKey.currentState!.validate()) {
                                Provider.of<AppLogin>(context, listen: false).otpVerification(context, data);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.black, backgroundColor: goldShade,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Send",
                                  style: TextStyle(color: darkShade),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 44.h),
                        // TextButton(
                        //   onPressed: () {
                        //     if (enableResend == true) {
                        //       Provider.of<AppLogin>(context, listen: false).requestPasswordReset(context,widget.data.toString(),);
                        //       _resendCode();
                        //     }else{
                        //       null;
                        //     }
                        //   },
                        //   child: Text(
                        //     "Resend OTP",
                        //     style: TextStyle(
                        //       color: enableResend ? goldShade : Colors.grey,
                        //       fontWeight: FontWeight.w500,
                        //       // Make text bold
                        //       decoration: TextDecoration.underline,
                        //       // Add underline decoration
                        //       decorationColor:
                        //       goldShade, // Set underline color to red
                        //     ),
                        //   ),
                        // )
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

