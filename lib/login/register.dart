import 'package:country_picker/country_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../constant/constant.dart';
import '../models/register_form.dart';
import '../widgets/customtextfield.dart';
import '../widgets/datepicker.dart';
import '../widgets/dropdownData.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers
  TextEditingController _dateController = TextEditingController();
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _dob = TextEditingController();
  TextEditingController _gender = TextEditingController();
  TextEditingController _country = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _zoomlanguage = TextEditingController();
  TextEditingController _rematrk = TextEditingController();

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

  String _inputValue = '';
  double radiusData = 16.sp;

  final TextEditingController _phoneController =
      TextEditingController(text: "");

  TextInputType getKeyboardType() {
    return _selectedCountry?.name == "India"
        ? TextInputType.phone
        : TextInputType.emailAddress;
  }

  List<TextInputFormatter> getInputFormatters() {
    if (_selectedCountry?.name == "India") {
      return [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ];
    }
    return [];
  }

  void autoFillPhoneNumber() async {
    if (_selectedCountry?.name == "India") {
      try {
        String? autoFilledPhone = await SmsAutoFill().hint;
        if (autoFilledPhone != null && autoFilledPhone.isNotEmpty) {
          setState(() {
            _phoneController.text = autoFilledPhone;
          });
        }
      } catch (e) {
        print("Failed to autofill phone number: $e");
      }
    }
  }

  // Validation helper function to restrict special characters and spaces
  String? validateField(String? value, String fieldName) {
    final RegExp nameRegExp =
        RegExp(r"^[A-Za-z\s]+$"); // Only allows alphabets and spaces
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    if (!nameRegExp.hasMatch(value.trim())) {
      return '$fieldName can only contain alphabets and spaces';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              ClipPath(
                clipper: CurvedBottomClipper(),
                child: Container(
                  height: 350.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: AssetImage(guruji),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sp),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 300.h),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("Satyam vada | Dharmam chara"),
                      ),
                      Divider(color: shadeNine.withOpacity(.5)),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.sp),
                        child: CustomTextField(
                          padding: true,
                          hintText: 'First name',
                          controller: _firstName,
                          validator: (value) =>
                              validateField(value, 'First name'),
                          required: true,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.sp),
                        child: CustomTextField(
                          padding: true,
                          hintText: 'Last name',
                          controller: _lastName,
                          validator: (value) =>
                              validateField(value, 'Last name'),
                          required: true,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.sp),
                        child: CustomTextField(
                          padding: true,
                          hintText: 'Email',
                          controller: _email,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            if (!EmailValidator.validate(value)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                          required: true,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.sp),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: DatePickerField(
                                hintText: 'Date of Birth',
                                controller: _dateController,
                              ),
                            ),
                            SizedBox(width: 8.sp),
                            Expanded(
                              flex: 1,
                              child: DropdownTextField(
                                hintText: "Gender",
                                controller: _gender,
                                items: ['Male', 'Female'],
                                dropdownHint: 'Gender',
                                onItemSelected: (val) => print(val.toString()),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showCountryPicker(
                            favorite: <String>['IN'],
                            context: context,
                            showPhoneCode: false,
                            onSelect: (Country country) {
                              setState(() {
                                _selectedCountry = country;
                                if (country.name == "India") {
                                  autoFillPhoneNumber();
                                }
                              });
                            },
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.sp),
                          child: Container(
                            height: 56.h,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: profileTextFieldDillColor,
                              border: Border.all(color: shadeNine),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    "${_selectedCountry?.name ?? "Select Country"}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.arrow_drop_down, size: 18.sp),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.sp),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(radiusData)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: profileTextFieldDillColor,
                                  border: Border.all(color: shadeNine),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                ),
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.sp),
                                  child: Text(
                                    _selectedCountry?.flagEmoji ?? "🇮🇳",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 36),
                                  ),
                                ),
                              ),
                              SizedBox(width: 4.sp),
                              Expanded(
                                child: CustomTextField(
                                  hintText: 'Phone',
                                  required: true,
                                  padding: true,
                                  controller: _phone,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter your phone';
                                    }
                                    if (_selectedCountry?.name == "India") {
                                      if (value.trim().length != 10) {
                                        return 'Please enter a valid 10-digit phone number';
                                      }
                                    } else {
                                      if (value.trim().length < 9 ||
                                          value.trim().length > 13) {
                                        return 'Please enter a valid phone number with 9-13 digits';
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.sp),
                        child: DropdownTextField(
                          hintText: 'Select language for Online Zoom class',
                          controller: _zoomlanguage,
                          items: [
                            'English',
                            'Hindi',
                            'Kannada',
                            'Malayalam',
                            'Tamil',
                            'Telugu'
                          ],
                          dropdownHint: 'Select language for Zoom class',
                          onItemSelected: (val) => print(val.toString()),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.sp),
                        child: CustomTextField(
                          hintText: 'Special remarks',
                          controller: _rematrk,
                        ),
                      ),
                      SizedBox(
                        height: 56.h,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              await ApiService()
                                  .registerUser(
                                firstName: _firstName.text,
                                lastName: _lastName.text,
                                email: _email.text,
                                dob: _dateController.text,
                                gender: _gender.text,
                                country: _selectedCountry!.name.toString(),
                                phone: _phone.text,
                                reference: 'social media',
                                refId: '00000',
                                languages: _zoomlanguage.text,
                                remark: _rematrk.text,
                                profilePic: null,
                                context: context,
                              )
                                  .then((dynamic value) {
                                print(
                                    'Response: $value'); // Print the response in console
                              }).catchError((error) {
                                print(
                                    'Error: $error'); // Print any error in console
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.black,
                            backgroundColor: goldShade,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Submit",
                                  style: TextStyle(color: darkShade)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 36.h,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 100); // Start the curve just before the bottom
    var controlPoint = Offset(size.width / 2, size.height);
    var endPoint = Offset(size.width, size.height - 100);

    // Draw a quadratic curve for the curved bottom
    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );

    path.lineTo(size.width, 0); // Complete the path by going to the top-right
    path.close(); // Close the path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
