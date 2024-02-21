import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/constant.dart'; // Assuming this file contains the 'appTheam' constant
import 'package:flutter/material.dart';
import '../../controller/providerdata.dart';
import '../../main.dart';
import '../../services/appointment_api.dart';


class AppointmentPage extends StatefulWidget {
  const AppointmentPage({Key? key}) : super(key: key);
  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  // Variables
  var pickupFrom ="";
  // String phone = "";
  bool _pickup = false;

  // validation Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // text Controllers

  final TextEditingController _appointmentDate = TextEditingController();
  final TextEditingController _noOfDays = TextEditingController();
  final TextEditingController _noOfPeople = TextEditingController();
  final TextEditingController _pickupPoint = TextEditingController();
  final  TextEditingController _destination = TextEditingController(text: "Asramam");
  final  TextEditingController _emergencyContact = TextEditingController();
  final TextEditingController _reason = TextEditingController();
  final TextEditingController _registeredPhone = TextEditingController();



  // ViewState
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _appointmentDate.dispose();
    super.dispose();
  }



  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, proceed with form submission
      var time = TimeOfDay.now();
      var date = DateTime.now();
      int? numOfPeople = int.tryParse(_noOfPeople.text);
      print("${time.hour}:${time.minute}");
      Map<String, dynamic> data = {
        "appointmentDate": _appointmentDate.text,
        "num_of_people": numOfPeople,
        "pickup": _pickup ,
        "days": _noOfDays.text,
        "from": pickupFrom.isEmpty ? "No Data":pickupFrom,
        "emergencyNumber": _emergencyContact.text,
        "appointment_time": "${time.hour}:${time.minute}",
        "appointment_reason": _reason.text,
        "register_date": "${date.day}-${date.month}-${date.year}"
      };
     await postAppointment(context, data);
    }
  }

  void clearTextControllers() {
    _appointmentDate.clear();
    _noOfDays.clear();
    _noOfPeople.clear();
    _pickupPoint.clear();
    _emergencyContact.clear();
    _reason.clear();
    _registeredPhone.clear();
  }



  // WidgetTree

  @override
  Widget build(BuildContext context) {
   const int maxCharacters = 100; // Maximum characters allowed
   const int digitLimit = 2; // Maximum characters allowed

     spaceBetween = SizedBox(height: 16.h,);

    return SafeArea(
      child:GestureDetector(
        onTap: () {
          if (!FocusScope.of(context).hasPrimaryFocus) {
            FocusScope.of(context).unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: pageBackground,
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  clearTextControllers();
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: pageBackground,
                )),
            backgroundColor: appbar,
            title: Text(
              bookAppointment,
              style: TextStyle(color: pageBackground),
            ),
            // centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.fromLTRB(10.sp, 15.sp, 10.sp, 10.sp),
              child: Form(
                key: _formKey,
                child:  Container(
                  // height: height / 1.15,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      spaceBetween,
                    spaceBetween,
                      TextFormField(
                        style: TextStyle(color: inputText),
                        onTap: () async {
                          var datePicked = await DatePicker.showSimpleDatePicker(
                            context,
                            firstDate: DateTime.now(),
                            dateFormat: "dd/MM/yyyy",
                            locale: DateTimePickerLocale.en_us,
                            lastDate:DateTime(DateTime.now().year, 12, 31),
                          );
                          if (datePicked != null) {
                            var date = DateFormat('dd/MM/yyyy').format(datePicked);
                            _appointmentDate.text = date;
                            setState(() {});
                          }
                        },
                        controller: _appointmentDate,
                        readOnly: true,
                        keyboardType: TextInputType.datetime,
                        cursorColor: textFieldOutline,
                        inputFormatters: [DateTextFormatter()],
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () async {
                              var datePicked = await DatePicker.showSimpleDatePicker(
                                context,
                                firstDate: DateTime.now(),
                                dateFormat: "dd/MM/yyyy",
                                locale: DateTimePickerLocale.en_us,
                                lastDate:DateTime(DateTime.now().year, 12, 31),
                              );
                              if (datePicked != null) {
                                var date = DateFormat('dd/MM/yyyy').format(datePicked);
                                _appointmentDate.text = date;
                                setState(() {});
                              }
                            },
                            icon: Icon(
                              Icons.calendar_month,color: iconColor,
                              size: 20.sp,
                            ),
                          ),
                          label: Text(
                            appointmentDate,
                            style: TextStyle(color: placeHolder),
                          ),
                          hintText: ddMmYyyy,
                          labelStyle: TextStyle(
                            color: placeHolder,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.normal,

                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: textFieldOutline),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: onSelectTextFieldOutline,width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select appointment date';
                          }
                          return null;
                        },
                      ),
                      spaceBetween,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: TextFormField(
                              style: TextStyle(color: inputText),
                              controller: _noOfPeople,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(digitLimit),
                              ],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                label: Text(
                                  noOfPeople,
                                  style: TextStyle(color: placeHolder),
                                ),
                                labelStyle: TextStyle(
                                  color: textFieldOutline,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.normal,
                                ),
                                suffix: InkWell(
                                  onTap: () {
                                    _noOfPeople.clear();
                                  },
                                  child: Icon(Icons.highlight_off_outlined,color: iconColor,),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: textFieldOutline),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: onSelectTextFieldOutline,width: 2),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'No. of people required';
                                }
                                // Validate if the entered value is a valid integer
                                final intValue = int.tryParse(value);
                                if (intValue == null || intValue <= 0) {
                                  return 'Valid number please';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: 16.w,
                          ),
                          Flexible(
                            child: TextFormField(
                              style: TextStyle(color: inputText),
                              controller: _noOfDays,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(digitLimit),
                              ],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                label: Text(
                                  noOfDays,
                                  style: TextStyle(color: placeHolder),
                                ),
                                labelStyle: TextStyle(
                                  color: textFieldOutline,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                                suffix: InkWell(
                                  onTap: () {
                                    _noOfDays.clear();
                                  },
                                  child: Icon(Icons.highlight_off_outlined,color: iconColor,),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: textFieldOutline),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: onSelectTextFieldOutline,width: 2),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'No. of days required';
                                }
                                // Validate if the entered value is a valid integer
                                final intValue = int.tryParse(value);
                                if (intValue == null || intValue <= 0) {
                                  return 'Valid number please';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            side:  BorderSide(color:textFieldOutline,width: 2),
                            activeColor: textFieldOutline,
                              value: _pickup,
                              onChanged: (val) {
                                setState(() {
                                  _pickup = !_pickup;
                                });
                              }),
                          const Text(pickupCheckbox)
                        ],
                      ),
                      if (_pickup == true)
                        TextFormField(
                          style: TextStyle(color: inputText),
                          controller: _pickupPoint,
                          maxLength: maxCharacters,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            label: Text(pickUpPoint,),
                            labelStyle: TextStyle(
                                color: placeHolder,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.normal),
                            suffix: InkWell(
                                onTap: () {
                                  _pickupPoint.clear();
                                },
                                child: Icon(Icons.highlight_off_outlined,color: iconColor,)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: textFieldOutline),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: onSelectTextFieldOutline,width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a Valid Pickup Point';
                            }
                            return null;
                          },
                          onChanged: (val){
                            pickupFrom = val;
                          },
                        ),
                      if (_pickup == true) spaceBetween,
                      if (_pickup == true)
                        TextField(
                          style: TextStyle(color: inputText),
                          controller: _destination,
                          readOnly: true,
                          decoration: InputDecoration(
                            label: Text(destination,
                               ),
                            labelStyle: TextStyle(
                                color: placeHolder,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.normal),
                            // suffix: InkWell(
                            //     onTap: () {
                            //       _destination.clear();
                            //     },
                            //     child: Icon(Icons.highlight_off_outlined)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: textFieldOutline),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: onSelectTextFieldOutline,width: 2),
                            ),
                          ),
                        ),
                      if (_pickup == true)
                        spaceBetween,
                      TextFormField(
                        style: TextStyle(color: inputText),
                        controller: _emergencyContact,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          label: Text(emergencyContact),
                          labelStyle: TextStyle(
                              color: placeHolder,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.normal),
                          suffix: InkWell(
                              onTap: () {
                                _emergencyContact.clear();
                              },
                              child: Icon(Icons.highlight_off_outlined,color: iconColor,)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: textFieldOutline),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: onSelectTextFieldOutline,width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone number is required';
                          }
                          // Define a regular expression for validating phone numbers
                          final RegExp phoneRegex = RegExp(r'^\+?[0-9]{7,13}$');
                          // Allows for optional '+91' country code followed by 7 to 13 digits

                          // Check if the entered value matches the phone number format
                          if (!phoneRegex.hasMatch(value)) {
                            return 'Enter a valid phone number';
                          }
                          return null;
                        },


                      ),
                      spaceBetween,
                      TextFormField(
                        style: TextStyle(color: inputText),
                        controller: _reason,
                        maxLength: maxCharacters,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          label: Text(
                            remark,
                          ),
                          labelStyle: TextStyle(
                            color: placeHolder,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                          suffix: InkWell(
                            onTap: () {
                              _reason.clear();
                            },
                            child: Icon(Icons.highlight_off_outlined,color: iconColor,),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: textFieldOutline),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: onSelectTextFieldOutline,width: 2),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 36.h,
                      ),
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                            onPressed: ()async{
                              await _submitForm();
                             await Provider.of<ProviderController>(context, listen: false).fetchAppointments();
                              // fetchAppointments();
                            },
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.black, // Customize the shadow color
                            elevation: 4, // Adjust the elevation for the shadow
                            // Customize the background color
                            primary: buttonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  16), // Adjust the radius as needed
                            ), // Example color, change it according to your preference
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check,
                                color: buttonText,
                              ),
                              Text(
                                confirmBooking,
                                style: TextStyle(color: buttonText),
                              ),
                            ],
                          ),
                        ),
                      ),
                      spaceBetween,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
