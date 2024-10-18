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
  final _formKey = GlobalKey<FormState>();

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

  // Validator for alphabetic text (supports spaces)
  String? _validateAlphabetic(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Please enter only alphabets';
    }
    return null;
  }

  // Validator for phone number (only digits, max 15 digits)
  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    // Updated regex to match the criteria: starting with '+' (optional) followed by 9 to 15 digits
    if (!RegExp(r'^\+?[0-9]{9,15}$').hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  // Validator for address (no special characters)
  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (!RegExp(r'^[a-zA-Z0-9\s.,]+$').hasMatch(value)) {
      return 'Enter Valid Address';
    }
    return null;
  }

  // Validator for pin code (exactly 6 digits)
  String? _validatePinCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) {
      return 'Pin code must be exactly 6 digits';
    }
    return null;
  }

  // Validator for email (must be a valid email format)
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (!RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
        .hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Validator for Date of Birth (valid format DD/MM/YYYY or YYYY/MM/DD)
  String? _validateDOB(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date of birth is required';
    }
    // Regular expression to match DD/MM/YYYY or YYYY/MM/DD formats
    if (!RegExp(r'^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/[0-9]{4}$')
            .hasMatch(value) &&
        !RegExp(r'^[0-9]{4}/(0[1-9]|1[0-2])/(0[1-9]|[12][0-9]|3[01])$')
            .hasMatch(value)) {
      return 'Enter a valid date (DD/MM/YYYY or YYYY/MM/DD)';
    }

    // Parse the date to ensure it's valid and not in the future
    DateTime? parsedDate;
    try {
      final components = value.contains('/') ? value.split('/') : [];
      if (components.length == 3) {
        if (components[0].length == 4) {
          // YYYY/MM/DD
          parsedDate = DateTime(int.parse(components[0]),
              int.parse(components[1]), int.parse(components[2]));
        } else {
          // DD/MM/YYYY
          parsedDate = DateTime(int.parse(components[2]),
              int.parse(components[1]), int.parse(components[0]));
        }
      }
      if (parsedDate == null || parsedDate.isAfter(DateTime.now())) {
        return 'Date of birth cannot be in the future';
      }
    } catch (e) {
      return 'Invalid date';
    }

    return null;
  }

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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    hintText: 'FirstName',
                    controller: _firstName,
                    prefixIcon: Icons.person,
                    validator: _validateAlphabetic,
                  ),
                  CustomTextField(
                    hintText: 'LastName',
                    controller: _lastName,
                    prefixIcon: Icons.person,
                    validator: _validateAlphabetic,
                  ),
                  CustomTextField(
                    hintText: 'Phone no.',
                    controller: _phoneNo,
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: _validatePhoneNumber,
                  ),
                  CustomTextField(
                    hintText: 'Date of Birth dd/mm/yyyy',
                    controller: _dateofBirth,
                    prefixIcon: Icons.cake,
                    validator: _validateDOB,
                  ),
                  CustomTextField(
                    hintText: 'Email',
                    controller: _email,
                    prefixIcon: Icons.email_outlined,
                    validator: _validateEmail,
                  ),
                  // CustomTextField(hintText: 'Emergency contact',controller: _emergencyContact,),
                  CustomTextField(
                    hintText: 'Address',
                    controller: _address,
                    prefixIcon: Icons.pin_drop_outlined,
                    validator: _validateAddress,
                  ),
                  CustomTextField(
                    hintText: 'PIN Code',
                    controller: _pinCode,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.location_on_outlined,
                    validator: _validatePinCode,
                  ),
                  CustomTextField(
                    hintText: 'District',
                    controller: _district,
                    prefixIcon: Icons.location_city_rounded,
                    validator: _validateAlphabetic,
                  ),
                  CustomTextField(
                    hintText: 'State',
                    controller: _state,
                    prefixIcon: Icons.location_city_rounded,
                    validator: _validateAlphabetic,
                  ),
                  // CustomTextField(
                  //   hintText: 'Country',
                  //   controller: _country,
                  //   prefixIcon: Icons.location_city_rounded,
                  // ),
                  // CustomTextField(hintText: 'Country',controller: _country,prefixIcon: Icons.,),
                  SizedBox(
                    height: 24,
                  ),
                  CustomButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
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
                            country: _country.text);
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
      ),
    );
  }
}
