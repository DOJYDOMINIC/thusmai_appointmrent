import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../constant/constant.dart';
import 'package:http/http.dart' as http;

import '../../controller/providerdata.dart';
import 'changepassword.dart';
import 'login.dart';



class otpPage extends StatefulWidget {
  const otpPage({Key? key,  this.data}) : super(key: key);
final data;
  @override
  State<otpPage> createState() => _otpPageState();
}

class _otpPageState extends State<otpPage> {
  var  focusedBorderColor = buttonColor;
  var fillColor = inputText;
  var borderColor = buttonColor;




  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  var otpNumber;



  Future<void> otpVerification() async {
    print(otpNumber.toString());
    print(widget.data["email"].toString());
    final response = await http.post(Uri.parse("$baseUrl/verify-userotp"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"otp":otpNumber,"email": widget.data["email"],}));

    var decode = jsonDecode(response.body);
    try {
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.green,
            content: Text(decode["message"]),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChangePassword(data: widget.data["email"]),
            ));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red,
            content: Text(decode["error"]),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      print("Login Error : $e");
    }
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ProviderController>(context,listen: false);
    String phoneNumber = widget.data["phone"]??"+910000001234";
    String formattedPhoneNumber = phoneNumber.substring(0, 3) + "******" + phoneNumber.substring(9);

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
    return  GestureDetector(
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
                              IconButton(onPressed: (){
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => Login(),));
                                // Navigator.pop(context);
                                Navigator.pop(context);
                              }, icon: Icon(Icons.arrow_back_ios,color: Colors.white)),
                              SizedBox(width: 20.w,),
                              Text("OTP Verification",style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal),),
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
                            Text("Enter the four digit code we sent to",style:TextStyle(fontSize: 12.sp,color: Colors.white),),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Text(formattedPhoneNumber,style:TextStyle(fontSize: 12.sp,color: Colors.white),),
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
                            textStyle: TextStyle(color: Colors.white,fontSize: 24),
                            decoration: defaultPinTheme.decoration!.copyWith(
                              borderRadius: BorderRadius.circular(8), // Set border radius here
                            ),
                          ),
                          // validator: (value) {
                          //   if(otpvalidate == true ){
                          //     return value == value.toString() ? null : 'Pin is incorrect';
                          //   }else if (otpvalidate == false){
                          //     return value == "value" ? null : 'Pin is incorrect';
                          //   }
                          //   return null;
                          //
                          // },
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
                            textStyle: TextStyle(color: Colors.white,fontSize: 24),
                            decoration: defaultPinTheme.decoration!.copyWith(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: focusedBorderColor,width: 2),
                            ),
                          ),
                    
                          submittedPinTheme: defaultPinTheme.copyWith(
                            textStyle: TextStyle(color: Colors.white,fontSize: 24),
                            decoration: defaultPinTheme.decoration!.copyWith(
                              color: fillColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: focusedBorderColor,width: 2),
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
                      Text("Resend OTP in 00:${pro.seconds} ",style: TextStyle(fontSize: 16.sp,color: Colors.white),),
                      // TextButton(
                      //   onPressed: () {
                      //     focusNode.unfocus();
                      //     formKey.currentState!.validate();
                      //
                      //   },
                      //   child: const Text('Validate'),
                      // ),
                      SizedBox(
                        height: 40.h,
                      ),
                      SizedBox(
                        height: 56.h,
                        width: 304.w,
                        child: ElevatedButton(
                          onPressed: () {
                            otpVerification();
                          },
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.black,
                            elevation: 4,
                            primary: pro.seconds == 20 ? buttonColor : Colors.grey,
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
                      SizedBox(height: 10.h,),
                      TextButton(
                        onPressed: () {

                        },
                        child: Text(
                          "Resend OTP",
                          style: TextStyle(
                            color: buttonColor,
                            fontWeight: FontWeight.bold, // Make text bold
                            decoration: TextDecoration.underline, // Add underline decoration
                            decorationColor:buttonColor, // Set underline color to red
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