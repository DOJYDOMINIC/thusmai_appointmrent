import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/models/update_user_details.dart';

import '../../../constant/constant.dart';
import '../../../controller/login_register_otp_api.dart';
import '../../../controller/profileController.dart';
import '../../../widgets/custombutton.dart';
import '../../../widgets/customtextfield.dart';

class ProfileDetailsEdit extends StatefulWidget {
  const ProfileDetailsEdit({Key? key}) : super(key: key);

  @override
  State<ProfileDetailsEdit> createState() => _ProfileDetailsEditState();
}

class _ProfileDetailsEditState extends State<ProfileDetailsEdit> {
  String? _dobError;
  String? _emailError;
  String? _firstNameError;
  String? _lastNameError;
  String? _phoneError;
  String? _addressError;
  String? _pinCodeError;
  String? _districtError;
  String? _stateError;
  @override
  void initState() {
    super.initState();
    var userdata = Provider.of<AppLogin>(context, listen: false).userData;
    _firstName = TextEditingController(text: userdata?.firstName);
    _lastName = TextEditingController(text: userdata?.lastName);
    _phoneNo = TextEditingController(text: userdata?.phone);
    _dateofBirth =
        TextEditingController(text: userdata?.dob?.replaceAll('-', '/'));
    _email = TextEditingController(text: userdata?.email);
    _pinCode = TextEditingController(text: userdata?.pincode.toString());
    _state = TextEditingController(text: userdata?.state);
    _district = TextEditingController(text: userdata?.district);
    _address = TextEditingController(text: userdata?.address);
    _country = TextEditingController(text: userdata?.country);
  }

  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _phoneNo = TextEditingController();
  TextEditingController _dateofBirth = TextEditingController();
  TextEditingController _email = TextEditingController();

  // TextEditingController   _emergencyContact =    TextEditingController();
  TextEditingController _pinCode = TextEditingController();
  TextEditingController _state = TextEditingController();
  TextEditingController _district = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _country = TextEditingController();

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
          "Edit personal info",
          style: TextStyle(color: shadeOne),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                CustomTextField(
                  hintText: 'FirstName',
                  controller: _firstName,
                  prefixIcon: Icons.person,
                  errorText: _firstNameError,
                ),
                CustomTextField(
                  hintText: 'LastName',
                  controller: _lastName,
                  prefixIcon: Icons.person,
                  errorText: _lastNameError,
                ),
                CustomTextField(
                  hintText: 'Phone no.',
                  controller: _phoneNo,
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  errorText: _phoneError,
                ),
                CustomTextField(
                  hintText: 'Date of Birth',
                  controller: _dateofBirth,
                  prefixIcon: Icons.cake,
                  errorText: _dobError,
                ),
                CustomTextField(
                  hintText: 'Email',
                  controller: _email,
                  prefixIcon: Icons.email_outlined,
                  errorText: _emailError,
                ),
                // CustomTextField(hintText: 'Emergency contact',controller: _emergencyContact,),
                CustomTextField(
                  hintText: 'Address',
                  controller: _address,
                  prefixIcon: Icons.pin_drop_outlined,
                  errorText: _addressError,
                ),
                CustomTextField(
                  hintText: 'PIN Code',
                  controller: _pinCode,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.location_on_outlined,
                  errorText: _pinCodeError,
                ),
                CustomTextField(
                  hintText: 'District',
                  controller: _district,
                  prefixIcon: Icons.location_city_rounded,
                  errorText: _districtError,
                ),
                CustomTextField(
                  hintText: 'State',
                  controller: _state,
                  prefixIcon: Icons.location_city_rounded,
                  errorText: _stateError,
                ),
                SizedBox(
                  height: 24,
                ),
                // CustomTextField(
                //   hintText: 'Country',
                //   controller: _country,
                //   prefixIcon: Icons.location_city_rounded,
                // ),
                // CustomTextField(hintText: 'Country',controller: _country,prefixIcon: Icons.,),
                // CustomButton(
                //   onPressed: () {
                //     UpdateUserDetail data = UpdateUserDetail(
                //         firstName: _firstName.text.toUpperCase(),
                //         lastName: _lastName.text.toUpperCase(),
                //         phone: _phoneNo.text,
                //         dob: _dateofBirth.text,
                //         email: _email.text,
                //         pincode: int.parse(_pinCode.text),
                //         state: _state.text.toUpperCase(),
                //         district: _district.text.toUpperCase(),
                //         address: _address.text.toUpperCase(),
                //       country: _country.text
                //     );
                //     Provider.of<ProfileController>(context,listen: false).profileEdit(context,data);
                //   },
                //   buttonColor: goldShade,
                //   buttonText: "Save",
                // )
                CustomButton(
                  onPressed: () {
                    String dob = _dateofBirth.text.trim();
                    String email = _email.text.trim();
                    String firstName = _firstName.text.trim();
                    String lastName = _lastName.text.trim();
                    String phone = _phoneNo.text.trim();
                    String address = _address.text.trim();
                    String pinCode = _pinCode.text.trim();
                    String district = _district.text.trim();
                    String state = _state.text.trim();

                    setState(() {
                      // First Name and Last Name Validation (only alphabets and spaces)
                      if (!RegExp(r'^[A-Za-z\s]+$').hasMatch(firstName)) {
                        _firstNameError = "Only alphabets are allowed";
                      } else {
                        _firstNameError = null;
                      }

                      if (!RegExp(r'^[A-Za-z\s]+$').hasMatch(lastName)) {
                        _lastNameError = "Only alphabets are allowed";
                      } else {
                        _lastNameError = null;
                      }

                      // Phone number validation (max 15 digits)
                      if (phone.isEmpty ||
                          phone.length > 15 ||
                          !RegExp(r'^\d{1,15}$').hasMatch(phone)) {
                        _phoneError =
                            "Enter a valid phone number (up to 15 digits)";
                      } else {
                        _phoneError = null;
                      }

                      // Address validation (no special characters except dot and comma)
                      if (!RegExp(r'^[a-zA-Z0-9\s,\.]+$').hasMatch(address)) {
                        _addressError = "Invalid characters in address";
                      } else {
                        _addressError = null;
                      }

                      // PIN code validation (exactly 6 digits)
                      if (!RegExp(r'^\d{6}$').hasMatch(pinCode)) {
                        _pinCodeError = "PIN Code must be exactly 6 digits";
                      } else {
                        _pinCodeError = null;
                      }

                      // District and State validation (only alphabets)
                      if (!RegExp(r'^[A-Za-z]+$').hasMatch(district)) {
                        _districtError = "Only alphabets allowed";
                      } else {
                        _districtError = null;
                      }

                      if (!RegExp(r'^[A-Za-z]+$').hasMatch(state)) {
                        _stateError = "Only alphabets allowed";
                      } else {
                        _stateError = null;
                      }

                      // Date of Birth validation
                      if (!RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(dob) ||
                          dob == '00/00/0000') {
                        _dobError = "Please enter a valid Date of Birth";
                      } else {
                        _dobError = null;
                      }

                      // Email validation
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(email)) {
                        _emailError = "Please enter a valid email address";
                      } else {
                        _emailError = null;
                      }
                    });

                    // If no errors, proceed with profile update
                    if (_firstNameError == null &&
                        _lastNameError == null &&
                        _phoneError == null &&
                        _addressError == null &&
                        _pinCodeError == null &&
                        _districtError == null &&
                        _stateError == null &&
                        _dobError == null &&
                        _emailError == null) {
                      UpdateUserDetail data = UpdateUserDetail(
                        firstName: _firstName.text.toUpperCase(),
                        lastName: _lastName.text.toUpperCase(),
                        phone: _phoneNo.text,
                        dob: _dateofBirth.text,
                        email: _email.text,
                        pincode: int.parse(_pinCode.text),
                        state: _state.text.toUpperCase(),
                        district: _district.text.toUpperCase(),
                        address: _address.text.toUpperCase(),
                        country: _country.text,
                      );

                      // Call to profile edit method
                      Provider.of<ProfileController>(context, listen: false)
                          .profileEdit(context, data);
                    }
                  },
                  buttonColor: goldShade,
                  buttonText: "Save",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
