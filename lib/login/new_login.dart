import 'package:country_picker/country_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:mobile_number/sim_card.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:smart_auth/smart_auth.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../constant/constant.dart';
import '../../controller/login_register_otp_api.dart';
import '../services/permition_service.dart';
import 'otp_verification.dart';

class LoginUpdate extends StatefulWidget {
  const LoginUpdate({Key? key}) : super(key: key);

  @override
  State<LoginUpdate> createState() => _LoginUpdateState();
}

class _LoginUpdateState extends State<LoginUpdate> {
  final smartAuth = SmartAuth();
  late final SmsRetriever smsRetriever;

  Country? _selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "9123456789",
    displayName: "India",
    displayNameNoCountryCode: "India",
    e164Key: "91-IN-0",
  );
  String _mobileNumber = '';
  List<SimCard> _simCard = [];
  String _inputValue = '';
  double radiusData = 16.sp;
  static const IconData globe = IconData(0xf68d);
  final TextEditingController _phoneController = TextEditingController();

  TextInputType getKeyboardType() {
    return _selectedCountry?.name == "India"
        ? TextInputType.phone
        : TextInputType.emailAddress;
  }

  List<TextInputFormatter> getInputFormatters() {
    if (_selectedCountry?.name == "India") {
      return [
        FilteringTextInputFormatter.digitsOnly, // Only digits for phone
        LengthLimitingTextInputFormatter(10), // Limit phone number to 10 digits
      ];
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    smsRetriever = SmsRetrieverImpl(
      SmartAuth(),
    );
    requestPermissions();
    MobileNumber.listenPhonePermission((isPermissionGranted) {
      if (isPermissionGranted) {
        initMobileNumberState();
      }
    });

    Provider.of<AppLogin>(context, listen: false).listQuestions();
  }

  Future<void> initMobileNumberState() async {
    if (!await MobileNumber.hasPhonePermission) {
      await MobileNumber.requestPhonePermission;
      return;
    }

    try {
      _mobileNumber = (await MobileNumber.mobileNumber)!;
      _simCard = (await MobileNumber.getSimCards)!;

      // Print all available phone numbers from the SIM cards
      for (var sim in _simCard) {
        print('Phone number available: ${sim.number}');
      }
    } on PlatformException catch (e) {
      debugPrint("Failed to get mobile number because of '${e.message}'");
    }

    if (!mounted) return;
    setState(() {});
    fillCards();
  }

  // Future<void> initMobileNumberState() async {
  //
  //   if (!await MobileNumber.hasPhonePermission) {
  //     await MobileNumber.requestPhonePermission;
  //     return;
  //   }
  //
  //   try {
  //     _mobileNumber = (await MobileNumber.mobileNumber)!;
  //     _simCard = (await MobileNumber.getSimCards)!;
  //     print(_mobileNumber);
  //   } on PlatformException catch (e) {
  //     debugPrint("Failed to get mobile number because of '${e.message}'");
  //   }
  //
  //   if (!mounted) return;
  //   setState(() {});
  // }

  Widget fillCards() {
    List<Widget> widgets = _simCard
        .map((SimCard sim) => Text(
              'Sim Card Number: (${sim.countryPhonePrefix}) - ${sim.number}\nCarrier Name: ${sim.carrierName}\nCountry Iso: ${sim.countryIso}\nDisplay Name: ${sim.displayName}\nSim Slot Index: ${sim.slotIndex}\n\n',
            ))
        .toList();
    return Column(children: widgets);
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }

  void requestHint() async {
    try {
      final res = await smartAuth.requestHint(
        isPhoneNumberIdentifierSupported: true, // Supports phone number
        isEmailAddressIdentifierSupported: true, // Supports email
        showCancelButton: true, // Shows a cancel button
      );
      debugPrint('requestHint: $res');
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final bottomNavBarHeight = MediaQuery.of(context).padding.bottom;
    final screen = MediaQuery.of(context).size.height -
        statusBarHeight +
        bottomNavBarHeight;
    ScreenUtil.init(context, designSize: const Size(400, 880));

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
            physics: const ClampingScrollPhysics(),
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
                          SizedBox(height: 30.h),
                          Image(height: 64.h, image: const AssetImage(logo)),
                          SizedBox(height: 300.h),
                          Row(
                            children: [
                              Text(
                                "In stillness find the tranquil stream",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: darkShade,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(radiusData)),
                              border: Border.all(color: goldShade),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showCountryPicker(
                                      favorite: ['IN'],
                                      context: context,
                                      showPhoneCode:
                                          false, // Set to true if you want to show phone code
                                      onSelect: (Country country) {
                                        setState(() {
                                          _selectedCountry =
                                              country; // Update selected country
                                        });
                                      },
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      if (_selectedCountry != null)
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            _selectedCountry?.flagEmoji ??
                                                "", // Displays the flag emoji or 'Country' if null
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    24), // Adjust font size as needed
                                          ),
                                        ),
                                      if (_selectedCountry == null)
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.sp),
                                          child: Icon(
                                            globe,
                                            color: Colors.white,
                                          ),
                                        ),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Container(
                                    height: 45.h,
                                    width: 1,
                                    color: goldShade.withOpacity(.5)),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: TextFormField(
                                    autofillHints: [
                                      AutofillHints.telephoneNumber
                                    ],
                                    controller: _selectedCountry?.name ==
                                            "India"
                                        ? _phoneController
                                        : null, // Use the controller for India
                                    keyboardType:
                                        getKeyboardType(), // Dynamically set keyboard type
                                    inputFormatters:
                                        getInputFormatters(), // Dynamically set input formatters
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return _selectedCountry?.name == "India"
                                            ? 'Please enter your phone'
                                            : 'Please enter your email';
                                      }
                                      if (_selectedCountry?.name == "India") {
                                        if (value.trim().length != 10) {
                                          return 'Please enter a valid 10-digit phone number';
                                        }
                                      } else if (!EmailValidator.validate(
                                          value.trim())) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      _inputValue =
                                          value.replaceAll(' ', '').trim();
                                    },
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                    ),
                                    cursorColor: Colors.white,
                                    decoration: InputDecoration(
                                      hintText:
                                          _selectedCountry?.name == "India"
                                              ? "Phone"
                                              : "Email",
                                      hintStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      fillColor: darkShade,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(radiusData)),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),
                          SizedBox(height: 40.h),
                          SizedBox(
                            height: 56.h,
                            width: 304.w,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  Provider.of<AppLogin>(context, listen: false)
                                      .sendOtp(
                                    context,
                                    UserContactInfo(
                                      phone: _selectedCountry?.name == "India"
                                          ? _inputValue
                                          : null,
                                      country: _selectedCountry?.name,
                                      email: _selectedCountry?.name != "India"
                                          ? _inputValue
                                          : null,
                                    ),
                                  );
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
                              child: Center(
                                child: Text(
                                  "Proceed",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14.sp),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
