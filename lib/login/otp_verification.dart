import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:smart_auth/smart_auth.dart';
import '../../constant/constant.dart';
import '../../controller/login_register_otp_api.dart';

class otpPageData extends StatefulWidget {
  const otpPageData({Key? key, required this.data}) : super(key: key);

  final UserContactInfo data;

  @override
  State<otpPageData> createState() => _otpPageDataState();
}

class _otpPageDataState extends State<otpPageData> {
  var focusedBorderColor = goldShade;
  var fillColor = darkShade;
  var borderColor = goldShade;

  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  var otpNumber;
  late final SmsRetriever smsRetriever;
  int secondsRemaining = 30;
  bool enableResend = false;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    smsRetriever = SmsRetrieverImpl(
      SmartAuth(),
    );
    // Start the countdown timer
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
    // Other code for resending OTP here
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
                          IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.arrow_back_ios,
                                  color: Colors.white)),
                          SizedBox(width: 20.w),
                          Text("OTP Verification",
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Text("Enter the four digit code we sent to",
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.white)),
                          ],
                        ),
                      ),
                      SizedBox(height: 270.h),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Pinput(
                          smsRetriever: smsRetriever,
                          controller: pinController,
                          focusNode: focusNode,
                          defaultPinTheme: defaultPinTheme,
                          separatorBuilder: (index) => const SizedBox(width: 8),
                          onClipboardFound: (value) {
                            debugPrint('onClipboardFound: $value');
                            pinController.setText(value);
                          },
                          onCompleted: (pin) {
                            otpNumber = pin;
                            debugPrint('onCompleted: $pin');
                            // Call the verification method directly here if needed
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
                      SizedBox(height: 40.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            enableResend ? 'Resend OTP in ' : 'Resend OTP in ',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.sp),
                          ),
                          Text(
                            enableResend ? '00:30' : '00:$secondsRemaining',
                            style: TextStyle(color: goldShade, fontSize: 16.sp),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),
                      SizedBox(
                        height: 56.h,
                        width: 304.w,
                        child: ElevatedButton(
                          onPressed: () {
                            Provider.of<AppLogin>(context, listen: false)
                                .otpVerification(
                                    context, widget.data, otpNumber);
                            // print(widget.data.toString());
                            // Map<String, dynamic> data = {
                            //   "otp": otpNumber,
                            //   "email": widget.data,
                            // };
                            // print(data.toString());
                            // Provider.of<AppLogin>(context, listen: false).otpVerification(context, data);
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
                              Text("Verify",
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextButton(
                        onPressed: () {
                          if (enableResend) {
                            Provider.of<AppLogin>(context, listen: false)
                                .otpVerification(
                                    context, widget.data, otpNumber);

                            // _resendCode();
                          }
                        },
                        child: Text(
                          "Resend OTP",
                          style: TextStyle(
                            color: enableResend ? goldShade : Colors.grey,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: goldShade,
                          ),
                        ),
                      ),
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

class SmsRetrieverImpl implements SmsRetriever {
  const SmsRetrieverImpl(this.smartAuth);

  final SmartAuth smartAuth;

  @override
  Future<void> dispose() {
    return smartAuth.removeSmsListener();
  }

  @override
  Future<String?> getSmsCode() async {
    final signature = await smartAuth.getAppSignature();
    debugPrint('App Signature: $signature');
    final res = await smartAuth.getSmsCode(
      useUserConsentApi: true,
    );

    if (res.succeed && res.codeFound) {
      return res.code!;
    }
    return null;
  }

  @override
  bool get listenForMultipleSms => false;
}
