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
  @override
  void initState() {
    super.initState();
var userdata = Provider.of<AppLogin>(context,listen: false).userData;
    _firstName = TextEditingController(text: userdata?.firstName);
    _lastName = TextEditingController(text: userdata?.lastName);
    _phoneNo = TextEditingController(text: userdata?.phone);
    _dateofBirth = TextEditingController(text: userdata?.dob);
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
                ),
                CustomTextField(
                    hintText: 'LastName',
                    controller: _lastName,
                    prefixIcon: Icons.person),
                CustomTextField(
                  hintText: 'Phone no.',
                  controller: _phoneNo,
                  prefixIcon: Icons.phone,
                ),
                CustomTextField(
                  hintText: 'Date of Birth',
                  controller: _dateofBirth,
                  prefixIcon: Icons.cake,
                ),
                CustomTextField(
                  hintText: 'Email',
                  controller: _email,
                  prefixIcon: Icons.email_outlined,
                ),
                // CustomTextField(hintText: 'Emergency contact',controller: _emergencyContact,),
                CustomTextField(
                  hintText: 'PIN Code',
                  controller: _pinCode,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.location_on_outlined,
                ),
                CustomTextField(
                  hintText: 'State',
                  controller: _state,
                  prefixIcon: Icons.location_city_rounded,
                ),
                CustomTextField(
                  hintText: 'District',
                  controller: _district,
                  prefixIcon: Icons.location_city_rounded,
                ),
                CustomTextField(
                  hintText: 'Address',
                  controller: _address,
                  prefixIcon: Icons.pin_drop_outlined,
                ),
                // CustomTextField(hintText: 'Country',controller: _country,prefixIcon: Icons.,),
                SizedBox(
                  height: 24,
                ),
                CustomButton(
                  onPressed: () {
                    UpdateUserDetail data = UpdateUserDetail(
                        firstName: _firstName.text,
                        lastName: _lastName.text,
                        phone: _phoneNo.text,
                        dob: _dateofBirth.text,
                        email: _email.text,
                        pincode: int.parse(_pinCode.text),
                        state: _state.text,
                        district: _district.text,
                        address: _address.text);
                    Provider.of<ProfileController>(context,listen: false).profileEdit(context,data);
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
