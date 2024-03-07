import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/pages/appointment/termsandconditions.dart';
import '../../constant/constant.dart'; // Assuming this file contains the 'appTheam' constant
import 'package:flutter/material.dart';
import '../../controller/appointmentontroller_api.dart';


class AppointmentAddPage extends StatefulWidget {
  const AppointmentAddPage({Key? key}) : super(key: key);

  @override
  State<AppointmentAddPage> createState() => _AppointmentAddPageState();
}

class _AppointmentAddPageState extends State<AppointmentAddPage> {

  // Variables
  var pickupFrom ="";
  bool _pickup = false;
  bool _appointmentForOther = false;
  bool _termsAndCondition = false;

  // validation Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // text Controllers
  final TextEditingController _appointmentDate = TextEditingController();
  final TextEditingController _noOfDays = TextEditingController();
  final TextEditingController _noOfPeople = TextEditingController();
  final TextEditingController _pickupPoint = TextEditingController();
  // final  TextEditingController _destination = TextEditingController(text: "Asramam");
  final  TextEditingController _emergencyContact = TextEditingController();
  final TextEditingController _reason = TextEditingController();
  final TextEditingController _registeredPhone = TextEditingController();

  // ViewState
  @override
  void initState() {
    super.initState();
  }

  // dispose
  @override
  void dispose() {
    _appointmentDate.dispose();
    super.dispose();
  }




  // DatePicker
  DateTime _selectedDate = DateTime.now();
  final List<DateTime> _disabledDates = [
    DateTime(2024, 3, 10),
    DateTime(2024, 3, 15),
    DateTime(2024, 3, 20),
  ];
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? datePicked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
        firstDate: DateTime.now(),
        lastDate:DateTime(DateTime.now().year, 12, 31),
      selectableDayPredicate: (DateTime date) {
        // Disable dates from the _disabledDates list
        return !_disabledDates.contains(date);
      },
    );
    if (datePicked != null) {
      var date = DateFormat('dd/MM/yyyy').format(datePicked);
      _appointmentDate.text = date;
      setState(() {});
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {

      // Date time pick
      var time = TimeOfDay.now();
      var date = DateTime.now();
      // convert to int
      int? numOfPeople = int.tryParse(_noOfPeople.text);

      // Appointment Post Data
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
     //  Api call
     await Provider.of<AppointmentController>(context, listen: false).postAppointment(context, data);
    }
  }

  // Clear fields After Appointment
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
                  child: Column(
                    children: [
                      spaceBetween,
                    spaceBetween,
                      TextFormField(
                        style: TextStyle(color: inputText),
                        onTap: () {
                          _selectDate(context);
                        },
                        controller: _appointmentDate,
                        readOnly: true,
                        keyboardType: TextInputType.datetime,
                        cursorColor: textFieldOutline,
                        inputFormatters: [DateTextFormatter()],
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () async {
                              _selectDate(context);
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
                      // spaceBetween,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                              side:  BorderSide(color:textFieldOutline,width: 2),
                              activeColor: buttonText,
                              value: _appointmentForOther,
                              onChanged: (val) {
                                setState(() {
                                  _appointmentForOther = !_appointmentForOther;
                                });
                              }),
                          const Text(appointmentForOther)
                        ],
                      ),
                      Row(
                        children: [
                          Text("Personal Details"),
                        ],
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
                            activeColor: buttonText,
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
                      spaceBetween,
                      Row(
                        children: [
                          Checkbox(
                            activeColor: inputText,
                            value: _termsAndCondition,
                            onChanged: (value) {
                              _termsAndCondition = !_termsAndCondition;
                              setState(() {});
                            },
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "I hereby acknowledge that I have read and accept the ",
                                    style: TextStyle(fontSize: 14, color: inputText),
                                  ),
                                  TextSpan(
                                    text: "terms and conditions",
                                    style: TextStyle(fontSize: 14, color: buttonColor,fontWeight: FontWeight.bold),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration: Duration(milliseconds: 500),
                                            transitionsBuilder: (BuildContext context,
                                                Animation<double> animation,
                                                Animation<double> secAnimation,
                                                Widget child) {
                                              return SlideTransition(
                                                position: Tween<Offset>(
                                                  begin: Offset(1.0, 0.0),
                                                  end: Offset.zero,
                                                ).animate(animation),
                                                child: child,
                                              );
                                            },
                                            pageBuilder: (BuildContext context, Animation<double> animation,
                                                Animation<double> secAnimation) {
                                              return TermsAndConditions();
                                            },
                                          ),
                                        );
                                        // Add your code here to handle tap
                                        // print("Terms and conditions tapped!");

                                      },
                                  ),
                                  TextSpan(
                                    text: "governing appointments.",
                                    style: TextStyle(fontSize: 14, color: inputText),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 36.h,
                      ),
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                            onPressed: ()async{
                              await _submitForm();
                             await Provider.of<AppointmentController>(context, listen: false).fetchAppointments();
                            },
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.black, // Customize the shadow color
                            elevation: 4, // Adjust the elevation for the shadow
                            // Customize the background color
                            primary:_termsAndCondition == true? buttonColor : Colors.grey.shade700,
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
                                color:_termsAndCondition == true? buttonText: Colors.white,
                              ),
                              Text(
                                confirmBooking,
                                style: TextStyle(color: _termsAndCondition == true? buttonText: Colors.white),
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
