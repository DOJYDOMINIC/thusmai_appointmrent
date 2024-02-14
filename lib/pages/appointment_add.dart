import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:intl/intl.dart';
import '../constant/constant.dart'; // Assuming this file contains the 'appTheam' constant
import 'package:flutter/material.dart';
import '../services/appointment_api.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({Key? key}) : super(key: key);

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _pickup = false;

  var pickupFrom ="";

  final TextEditingController _appointmentDate = TextEditingController();
  final TextEditingController _noOfRooms = TextEditingController();
  final TextEditingController _noOfPeople = TextEditingController();
  final TextEditingController _pickupPoint = TextEditingController();
  final TextEditingController _destination =
      TextEditingController(text: "Asramam");
  final TextEditingController _emergencyContact = TextEditingController();
  final TextEditingController _reason = TextEditingController();
  final TextEditingController _registeredPhone = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, proceed with form submission
      var time = TimeOfDay.now();
      var date = DateTime.now();
      int? numOfPeople = int.tryParse(_noOfPeople.text);
      print("${time.hour}:${time.minute}");
      Map<String, dynamic> data = {
        "phone": _registeredPhone.text,
        "appointmentDate": _appointmentDate.text,
        "num_of_people": numOfPeople,
        "pickup": _pickup ,
        "room": _noOfRooms.text,
        "from": pickupFrom.isEmpty ? "No Data":pickupFrom,
        "emergencyNumber": _emergencyContact.text,
        "appointment_time": "${time.hour}:${time.minute}",
        "appointment_reason": _reason.text,
        "register_date": "${date.day}-${date.month}-${date.year}"
      };
      prefsSet("phone",_registeredPhone.text);
     await postAppointment(context, data);

    }
  }

  void clearTextControllers() {
    _appointmentDate.clear();
    _noOfRooms.clear();
    _noOfPeople.clear();
    _pickupPoint.clear();
    _emergencyContact.clear();
    _reason.clear();
    _registeredPhone.clear();
  }

  @override
  void dispose() {
    _appointmentDate.dispose();
    super.dispose();
  }

  // Corrected the super constructor syntax
  @override
  Widget build(BuildContext context) {
    int maxCharacters = 100; // Maximum characters allowed
    int digitLimit = 2; // Maximum characters allowed

    const spaceBetween = SizedBox(
      height: 16,
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: pageBackground,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                clearTextControllers();
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              icon: Icon(
                Icons.arrow_back,
                color: pageBackground,
              )),
          backgroundColor: textBoxBorder,
          title: Text(
            bookAppointment,
            style: TextStyle(color: pageBackground),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
            child: Form(
              key: _formKey,
              child:  Container(
                // height: height / 1.15,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    spaceBetween,
                  TextFormField(
                  controller: _registeredPhone,
                  keyboardType: TextInputType.phone,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Allow only digits
                    LengthLimitingTextInputFormatter(10), // Limit length to 10 digits
                  ],
                  decoration: InputDecoration(
                    label: Text(
                      "Registered Phone",
                      style: TextStyle(color: textBoxBorder),
                    ),
                    labelStyle: TextStyle(
                      color: textBoxBorder,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                    suffix: InkWell(
                      onTap: () {
                        _registeredPhone.clear();
                      },
                      child: Icon(Icons.highlight_off_outlined),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: textBoxBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: textBoxBorder),
                    ),
                  ),
                ),

                  spaceBetween,
                    TextFormField(
                      onTap: () async {
                        var datePicked = await DatePicker.showSimpleDatePicker(
                          context,
                          firstDate: DateTime.now(),
                          dateFormat: "dd-MM-yyyy",
                          locale: DateTimePickerLocale.en_us,
                        );
                        if (datePicked != null) {
                          var date = DateFormat('dd-MM-yyyy').format(datePicked);
                          _appointmentDate.text = date;
                          setState(() {});
                        }
                      },
                      controller: _appointmentDate,
                      readOnly: true,
                      keyboardType: TextInputType.datetime,
                      cursorColor: textBoxBorder,
                      inputFormatters: [DateTextFormatter()],
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () async {
                            var datePicked = await DatePicker.showSimpleDatePicker(
                              context,
                              firstDate: DateTime.now(),
                              dateFormat: "dd-MM-yyyy",
                              locale: DateTimePickerLocale.en_us,
                            );
                            if (datePicked != null) {
                              var date = DateFormat('dd-MM-yyyy').format(datePicked);
                              _appointmentDate.text = date;
                              setState(() {});
                            }
                          },
                          icon: Icon(
                            Icons.calendar_month,
                            size: 20,
                          ),
                        ),
                        label: Text(
                          appointmentDate,
                          style: TextStyle(color: textBoxBorder),
                        ),
                        hintText: ddMmYyyy,
                        labelStyle: TextStyle(
                          color: textBoxBorder,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: textBoxBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: textBoxBorder),
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
                            controller: _noOfPeople,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(digitLimit),
                            ],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              label: Text(
                                "No. of people",
                                style: TextStyle(color: textBoxBorder),
                              ),
                              labelStyle: TextStyle(
                                color: textBoxBorder,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                              suffix: InkWell(
                                onTap: () {
                                  _noOfPeople.clear();
                                },
                                child: Icon(Icons.highlight_off_outlined),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(color: textBoxBorder),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(color: textBoxBorder),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Number of people required';
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
                          width: 16,
                        ),
                        Flexible(
                          child: TextFormField(
                            controller: _noOfRooms,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(digitLimit),
                            ],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              label: Text(
                                "No. of rooms",
                                style: TextStyle(color: textBoxBorder),
                              ),
                              labelStyle: TextStyle(
                                color: textBoxBorder,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                              suffix: InkWell(
                                onTap: () {
                                  _noOfRooms.clear();
                                },
                                child: Icon(Icons.highlight_off_outlined),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(color: textBoxBorder),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(color: textBoxBorder),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'number of rooms required';
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Checkbox(
                          // fillColor: MaterialStatePropertyAll(textBoxBorder),
                          activeColor: textBoxBorder,
                            value: _pickup,
                            onChanged: (val) {
                              setState(() {
                                _pickup = !_pickup;
                              });
                            }),
                        Text("Pick Up ?")
                      ],
                    ),
                    if (_pickup == true)
                      TextField(
                        controller: _pickupPoint,
                        decoration: InputDecoration(
                          label: Text("Pickup Point",
                              style: TextStyle(color: textBoxBorder)),
                          labelStyle: TextStyle(
                              color: textBoxBorder,
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                          suffix: InkWell(
                              onTap: () {
                                _pickupPoint.clear();
                              },
                              child: Icon(Icons.highlight_off_outlined)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: textBoxBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: textBoxBorder),
                          ),
                        ),
                        onChanged: (val){
                          pickupFrom = val;
                        },
                      ),
                    if (_pickup == true) spaceBetween,
                    if (_pickup == true)
                      TextField(
                        controller: _destination,
                        readOnly: true,
                        decoration: InputDecoration(
                          label: Text("Destination",
                              style: TextStyle(color: textBoxBorder)),
                          labelStyle: TextStyle(
                              color: textBoxBorder,
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                          // suffix: InkWell(
                          //     onTap: () {
                          //       _destination.clear();
                          //     },
                          //     child: Icon(Icons.highlight_off_outlined)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: textBoxBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: textBoxBorder),
                          ),
                        ),
                      ),
                    if (_pickup == true)
                      spaceBetween,
                    TextFormField(
                      controller: _emergencyContact,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        label: Text("Emergency Contact",
                            style: TextStyle(color: textBoxBorder)),
                        labelStyle: TextStyle(
                            color: textBoxBorder,
                            fontSize: 16,
                            fontWeight: FontWeight.normal),
                        suffix: InkWell(
                            onTap: () {
                              _emergencyContact.clear();
                            },
                            child: Icon(Icons.highlight_off_outlined)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: textBoxBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: textBoxBorder),
                        ),
                      ),
                    ),
                    spaceBetween,
                    TextFormField(
                      controller: _reason,
                      maxLength: maxCharacters,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        label: Text(
                          "Reason",
                          style: TextStyle(color: textBoxBorder),
                        ),
                        labelStyle: TextStyle(
                          color: textBoxBorder,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                        suffix: InkWell(
                          onTap: () {
                            _reason.clear();
                          },
                          child: Icon(Icons.highlight_off_outlined),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: textBoxBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: textBoxBorder),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 36,
                    ),
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                          onPressed: ()async{
                            await _submitForm();
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
                              color: Colors.black,
                            ),
                            Text(
                              confirmBooking,
                              style: TextStyle(color: Colors.black),
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
