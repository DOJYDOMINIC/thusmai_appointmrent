import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../../constant/constant.dart';
import '../../controller/login_register_otp_api.dart';

class otpPage extends StatefulWidget {
  const otpPage({Key? key, this.data}) : super(key: key);

  final data;

  @override
  State<otpPage> createState() => _otpPageState();
}

class _otpPageState extends State<otpPage> {
  var focusedBorderColor = goldShade;
  var fillColor = darkShade;
  var borderColor = goldShade;

  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  var otpNumber;

  int secondsRemaining = 30;
  bool enableResend = false;
  late Timer timer;

  @override
  initState() {
    super.initState();
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
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    timer.cancel();
    super.dispose();
  }

  void _resendCode() {
    //other code here
    setState(() {
      secondsRemaining = 30;
      enableResend = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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

    /// Optionally you can use form to validate the Pinput
    return GestureDetector(
      onTap: () {
        if (!FocusScope.of(context).hasPrimaryFocus) {
          FocusScope.of(context).unfocus();
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
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
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    // Navigator.push(context, MaterialPageRoute(builder: (context) => Login(),));
                                    // Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.arrow_back_ios,
                                      color: Colors.white)),
                              SizedBox(
                                width: 20.w,
                              ),
                              Text(
                                "OTP Verification",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
                              ),
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
                            Text(
                              "Enter the four digit code we sent to",
                              style: TextStyle(
                                  fontSize: 12.sp, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            // Text(formattedPhoneNumber,style:TextStyle(fontSize: 12.sp,color: Colors.white),),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 270.h,
                      ),
                      Directionality(
                        // Specify direction if desired
                        textDirection: TextDirection.ltr,
                        child: Pinput(
                          controller: pinController,
                          focusNode: focusNode,
                          androidSmsAutofillMethod:
                              AndroidSmsAutofillMethod.smsUserConsentApi,
                          listenForMultipleSmsOnAndroid: true,
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
                      SizedBox(
                        height: 40.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            enableResend
                                ? 'Resend OTP in '
                                : 'Resend OTP in ',
                            style: TextStyle(color: Colors.white, fontSize: 16.sp),
                          ),
                          Text(
                            enableResend
                                ? '00:30'
                                : '00:$secondsRemaining',
                            style: TextStyle(color: goldShade, fontSize: 16.sp),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      SizedBox(
                        height: 56.h,
                        width: 304.w,
                        child: ElevatedButton(
                          onPressed: () {
                            Map<String, dynamic> data = {
                              "otp": otpNumber,
                              "email": widget.data,
                            };
                            Provider.of<AppLogin>(context, listen: false).otpVerification(context, data);
                          },
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.black,
                            elevation: 4,
                            primary: 20 == 20 ? goldShade : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Verify",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextButton(
                        onPressed: () {
                          if (enableResend == true) {
                            Provider.of<AppLogin>(context, listen: false).requestPasswordReset(context,widget.data.toString(),);
                            _resendCode();
                          }else{
                            null;
                          }
                        },
                        child: Text(
                          "Resend OTP",
                          style: TextStyle(
                            color: enableResend ? goldShade : Colors.grey,
                            fontWeight: FontWeight.bold,
                            // Make text bold
                            decoration: TextDecoration.underline,
                            // Add underline decoration
                            decorationColor:
                                goldShade, // Set underline color to red
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
