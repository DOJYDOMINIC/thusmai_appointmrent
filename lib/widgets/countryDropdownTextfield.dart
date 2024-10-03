import 'package:country_picker/country_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';
import 'package:sms_autofill/sms_autofill.dart';

class CountryDropdownTextField extends StatefulWidget {
  final String? initialCountry;
  const CountryDropdownTextField({Key? key, this.initialCountry}) : super(key: key);
  @override
  _CountryDropdownTextFieldState createState() => _CountryDropdownTextFieldState();
}

class _CountryDropdownTextFieldState extends State<CountryDropdownTextField> with CodeAutoFill {
  Country? _selectedCountry;
  String _inputValue = '';
  double radiusData = 16.sp;
  static const IconData globe = IconData(0xf68d,);
  final TextEditingController _phoneController = TextEditingController(text: ""); // Controller for the text field

  // Method to get the keyboard type based on selected country
  TextInputType getKeyboardType() {
    return _selectedCountry?.name == "India" ? TextInputType.phone : TextInputType.emailAddress;
  }

  // Method to apply input formatters based on selected country
  List<TextInputFormatter> getInputFormatters() {
    if (_selectedCountry?.name == "India") {
      return [
        FilteringTextInputFormatter.digitsOnly, // Only digits for phone
        LengthLimitingTextInputFormatter(10), // Limit phone number to 10 digits
      ];
    }
    return [];
  }

  // Automatically get the phone number if the user is from India
  void autoFillPhoneNumber() async {
    if (_selectedCountry?.name == "India") {
      try {
        String? autoFilledPhone = await SmsAutoFill().hint;
        if (autoFilledPhone != null && autoFilledPhone.isNotEmpty) {
          setState(() {
            _phoneController.text = autoFilledPhone; // Autofill phone number in the text field
          });
        }
      } catch (e) {
        // Handle exception if auto-fill fails
        print("Failed to autofill phone number: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    SmsAutoFill().listenForCode(); // Listen for the code autofill
  }

  @override
  void codeUpdated() {
    // This method will be triggered when the code is received
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: darkShade,
        borderRadius: BorderRadius.all(Radius.circular(radiusData)),
        border: Border.all(color: goldShade),
      ),
      child: Row(
        children: [
          // Country Picker Dropdown
          GestureDetector(
            onTap: () {
              showCountryPicker(
                context: context,
                showPhoneCode: false, // Set to true if you want to show phone code
                onSelect: (Country country) {
                  setState(() {
                    _selectedCountry = country; // Update selected country
                    if (country.name == "India") {
                      autoFillPhoneNumber(); // Autofill the phone number for India
                    }
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
                      _selectedCountry?.flagEmoji??"" , // Displays the flag emoji or 'Country' if null
                      style: TextStyle(color: Colors.white, fontSize: 24), // Adjust font size as needed
                    ),
                  ),
                if (_selectedCountry == null)
                Padding(
                  padding: EdgeInsets.only(left: 8.sp),
                  child: Icon(globe,color: Colors.white,),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Container(height: 45.h, width: 1, color: goldShade.withOpacity(.5)),
          SizedBox(width: 16.w),

          // TextFormField
          Expanded(
            child: TextFormField(
              controller: _selectedCountry?.name == "India" ? _phoneController : null, // Use the controller for India
              keyboardType: getKeyboardType(), // Dynamically set keyboard type
              inputFormatters: getInputFormatters(), // Dynamically set input formatters
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return _selectedCountry?.name == "India"
                      ? 'Please enter your phone'
                      : 'Please enter your email';
                }
                if (_selectedCountry?.name == "India") {
                  if (value.trim().length != 10) {
                    return 'Please enter a valid 10-digit phone number';
                  }
                } else if (!EmailValidator.validate(value.trim())) {
                  return 'Please enter a valid email';
                }
                return null;
              },
              onChanged: (value) {
                _inputValue = value.replaceAll(' ', '').trim();
              },
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
              ),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: _selectedCountry?.name == "India" ? "Phone" : "Email",
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
                fillColor: darkShade,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(radiusData)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
