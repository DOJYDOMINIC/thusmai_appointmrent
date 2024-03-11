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
  var pickupFrom = "";
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
  final TextEditingController _emergencyContact = TextEditingController();
  final TextEditingController _reason = TextEditingController();

  // var pro;

  // ViewState
  @override
  void initState() {
    super.initState();
  }

  // dispose
  @override
  void dispose() {
    _appointmentDate.dispose();
    _noOfDays.dispose();
    _noOfPeople.dispose();
    _pickupPoint.dispose();
    _emergencyContact.dispose();
    _reason.dispose();
    for (var controller in _groupMemberControllers) {
      controller.dispose();
    }
    for (var controller in _groupMemberAgeControllers) {
      controller.dispose();
    }
    for (var controller in _groupMemberRelationControllers) {
      controller.dispose();
    }
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
      lastDate: DateTime(DateTime.now().year, 12, 31),
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
        "pickup": _pickup,
        "days": _noOfDays.text,
        "from": pickupFrom.isEmpty ? "No Data" : pickupFrom,
        "emergencyNumber": _emergencyContact.text,
        "appointment_time": "${time.hour}:${time.minute}",
        "appointment_reason": _reason.text,
        "register_date": "${date.day}/${date.month}/${date.year}"
      };
      debugPrint(data.toString());
      //  Api call
      await Provider.of<AppointmentController>(context, listen: false).postAppointment(context, data);
    }
  }

  List<TextEditingController> _groupMemberAgeControllers = [];
  List<TextEditingController> _groupMemberRelationControllers = [];
  List<TextEditingController> _groupMemberControllers = [];

  // late List<TextEditingController> _groupMemberAgeControllers = List.generate(
  //   Provider.of<AppointmentController>(context).countOfPeople,
  //   (index) => TextEditingController(),
  // );
  // late List<TextEditingController> _groupMemberRelationControllers =
  //     List.generate(
  //       Provider.of<AppointmentController>(context).countOfPeople,
  //   (index) => TextEditingController(),
  // );
  // late List<TextEditingController> _groupMemberControllers = List.generate(
  //   Provider.of<AppointmentController>(context).countOfPeople,
  //   (index) => TextEditingController(),
  // );


  // WidgetTree
  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<AppointmentController>(context);

    List<Map<String, String>> dataList = [];
// Iterate through each index
    const int maxCharacters = 100; // Maximum characters allowed
    const int peopleDigitLimit = 1; // Maximum characters allowed
    const int daysDigitLimit = 2; // Maximum characters allowed
    print("rebuild tree");
    spaceBetween = SizedBox(
      height: 16.h,
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: pageBackground,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                pro.countOfPeople = 0;
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
            padding: EdgeInsets.fromLTRB(10.sp, 15.sp, 10.sp, 10.sp),
            child: Form(
              key: _formKey,
              child: Container(
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
                            Icons.calendar_month,
                            color: iconColor,
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
                          borderSide: BorderSide(
                              color: onSelectTextFieldOutline, width: 2),
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
                            side: BorderSide(color: textFieldOutline, width: 2),
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

                    // spaceBetween,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: TextFormField(
                            style: TextStyle(color: inputText),
                            onChanged: (value) {
                              if (_noOfPeople.text.isNotEmpty) {
                                pro.countOfPeople = int.parse(value);
                              } else {
                                pro.countOfPeople = 0;
                              }
                            },
                            controller: _noOfPeople,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(
                                  peopleDigitLimit),
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
                                  pro.countOfPeople = 0;
                                  _noOfPeople.clear();
                                },
                                child: Icon(
                                  Icons.highlight_off_outlined,
                                  color: iconColor,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(color: textFieldOutline),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: onSelectTextFieldOutline, width: 2),
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
                              LengthLimitingTextInputFormatter(daysDigitLimit),
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
                                child: Icon(
                                  Icons.highlight_off_outlined,
                                  color: iconColor,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(color: textFieldOutline),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: onSelectTextFieldOutline, width: 2),
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
                    if (_noOfPeople.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                        child: Row(
                          children: [
                            Text("Personal Details"),
                          ],
                        ),
                      ),
                    Container(
                      height: pro.countOfPeople * 205.h,
                      // Adjust the height based on the number of items
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: pro.countOfPeople,
                        itemBuilder: (context, index) {
                          _groupMemberControllers.add(TextEditingController());
                          _groupMemberAgeControllers
                              .add(TextEditingController());
                          _groupMemberRelationControllers
                              .add(TextEditingController());
                          print("rebuild");
                          return Padding(
                            padding: EdgeInsets.only(bottom: 16.sp),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 23.sp, right: 10.sp),
                                  child: Text("#${index + 1}"),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        style: TextStyle(color: inputText),
                                        controller:
                                            _groupMemberControllers[index],
                                        decoration: InputDecoration(
                                          label: Text(
                                            "Name",
                                            style: TextStyle(color: placeHolder),
                                          ),
                                          labelStyle: TextStyle(
                                            color: textFieldOutline,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          suffix: InkWell(
                                            onTap: () {
                                              _groupMemberControllers[index].clear();
                                            },
                                            child: Icon(
                                              Icons.highlight_off_outlined,
                                              color: iconColor,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5),
                                            borderSide: BorderSide(color: textFieldOutline),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5),
                                            borderSide: BorderSide(
                                                color: onSelectTextFieldOutline, width: 2),
                                          ),
                                        ),
                                        onChanged: (val) {
                                          // Handle onChanged
                                        },
                                      ),
                                      spaceBetween,
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              style:
                                                  TextStyle(color: inputText),
                                              controller:
                                                  _groupMemberAgeControllers[
                                                      index],
                                              decoration: InputDecoration(
                                                label: Text(
                                                  "Age",
                                                  style: TextStyle(color: placeHolder),
                                                ),
                                                labelStyle: TextStyle(
                                                  color: textFieldOutline,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                suffix: InkWell(
                                                  onTap: () {
                                                    _groupMemberAgeControllers[
                                                    index].clear();
                                                  },
                                                  child: Icon(
                                                    Icons.highlight_off_outlined,
                                                    color: iconColor,
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(5),
                                                  borderSide: BorderSide(color: textFieldOutline),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color: onSelectTextFieldOutline, width: 2),
                                                ),
                                              ),

                                              onChanged: (val) {
                                                // Handle onChanged
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 16.sp),
                                          Expanded(
                                            child: TextFormField(
                                              style:
                                                  TextStyle(color: inputText),
                                              controller:
                                                  _groupMemberRelationControllers[
                                                      index],
                                              decoration: InputDecoration(
                                                label: Text(
                                                  "Relation",
                                                  style: TextStyle(color: placeHolder),
                                                ),
                                                labelStyle: TextStyle(
                                                  color: textFieldOutline,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                suffix: InkWell(
                                                  onTap: () {
                                                    _groupMemberRelationControllers[
                                                    index].clear();
                                                  },
                                                  child: Icon(
                                                    Icons.highlight_off_outlined,
                                                    color: iconColor,
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(5),
                                                  borderSide: BorderSide(color: textFieldOutline),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color: onSelectTextFieldOutline, width: 2),
                                                ),
                                              ),
                                              onChanged: (val) {
                                                // Handle onChanged
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                            side: BorderSide(color: textFieldOutline, width: 2),
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
                          label: Text(
                            pickUpPoint,
                          ),
                          labelStyle: TextStyle(
                              color: placeHolder,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.normal),
                          suffix: InkWell(
                              onTap: () {
                                _pickupPoint.clear();
                              },
                              child: Icon(
                                Icons.highlight_off_outlined,
                                color: iconColor,
                              )),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: textFieldOutline),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: onSelectTextFieldOutline, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a Valid Pickup Point';
                          }
                          return null;
                        },
                        onChanged: (val) {
                          pickupFrom = val;
                        },
                      ),
                    if (_pickup == true) spaceBetween,
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
                            child: Icon(
                              Icons.highlight_off_outlined,
                              color: iconColor,
                            )),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: textFieldOutline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: onSelectTextFieldOutline, width: 2),
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
                          child: Icon(
                            Icons.highlight_off_outlined,
                            color: iconColor,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: textFieldOutline),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: onSelectTextFieldOutline, width: 2),
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
                                  text:
                                      "I hereby acknowledge that I have read and accept the ",
                                  style:
                                      TextStyle(fontSize: 14, color: inputText),
                                ),
                                TextSpan(
                                  text: "Terms and conditions ",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: buttonColor,
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          transitionDuration:
                                              Duration(milliseconds: 500),
                                          transitionsBuilder: (BuildContext
                                                  context,
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
                                          pageBuilder: (BuildContext context,
                                              Animation<double> animation,
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
                                  style:
                                      TextStyle(fontSize: 14, color: inputText),
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
                      height: 56.sp,
                      child: ElevatedButton(
                        onPressed: () async {
                          for (int i = 0; i < pro.countOfPeople; i++) {
                            // Create a map to store data for each index
                            Map<String, String> dataMap = {
                              'name': _groupMemberControllers[i].text,
                              'age': _groupMemberAgeControllers[i].text,
                              'relation':
                                  _groupMemberRelationControllers[i].text,
                            };
                            // Add the map to the list
                            dataList.add(dataMap);
                          }
                          print(dataList.toString());
                          await _submitForm();
                          await Provider.of<AppointmentController>(context, listen: false).fetchAppointments();
                        },
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.black,
                          // Customize the shadow color
                          elevation: 4,
                          // Adjust the elevation for the shadow
                          // Customize the background color
                          primary: _termsAndCondition == true
                              ? buttonColor
                              : Colors.grey.shade700,
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
                              color: _termsAndCondition == true
                                  ? buttonText
                                  : Colors.white,
                            ),
                            Text(
                              confirmBooking,
                              style: TextStyle(
                                  color: _termsAndCondition == true
                                      ? buttonText
                                      : Colors.white),
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
    );
  }
}
