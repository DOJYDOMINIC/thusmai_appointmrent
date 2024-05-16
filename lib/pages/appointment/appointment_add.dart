// import 'package:flutter/gestures.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:thusmai_appointmrent/models/appointment_model.dart';
// import 'package:thusmai_appointmrent/pages/appointment/termsandconditions.dart';
// import '../../constant/constant.dart'; // Assuming this file contains the 'appTheam' constant
// import 'package:flutter/material.dart';
// import '../../controller/appointmentontroller.dart';
// import '../../models/userdata.dart';
//
// class AppointmentEditPage extends StatefulWidget {
//   const AppointmentEditPage({super.key, required this.data,});
//   final ListElement  data;
//
//   @override
//   State<AppointmentEditPage> createState() => _AppointmentEditPageState();
// }
//
// class _AppointmentEditPageState extends State<AppointmentEditPage> {
//   // Variables
//   var pickupFrom = "";
//   bool _pickup = true;
//   bool _appointmentForOther = false;
//   bool _termsAndCondition = false;
//
//   // validation Key
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   // text Controllers
//   final TextEditingController _appointmentDate = TextEditingController();
//   final TextEditingController _noOfDays = TextEditingController();
//   final TextEditingController _noOfPeople = TextEditingController();
//   final TextEditingController _pickupPoint = TextEditingController();
//   final TextEditingController _emergencyContact = TextEditingController();
//   final TextEditingController _reason = TextEditingController();
//
//   // var pro;
//
//   // ViewState
//   @override
//   void initState() {
//     super.initState();
//   }
//
//
//   // dispose
//   @override
//   void dispose() {
//     _appointmentDate.dispose();
//     _noOfDays.dispose();
//     _noOfPeople.dispose();
//     _pickupPoint.dispose();
//     _emergencyContact.dispose();
//     _reason.dispose();
//     // for (var controller in _groupMemberControllers) {
//     //   controller.dispose();
//     // }
//     // for (var controller in _groupMemberAgeControllers) {
//     //   controller.dispose();
//     // }
//     // for (var controller in _groupMemberRelationControllers) {
//     //   controller.dispose();
//     // }
//     super.dispose();
//   }
//
//   // DatePicker
//   DateTime _selectedDate = DateTime.now();
//   final List<DateTime> _disabledDates = [
//     DateTime(2024, 3, 10),
//     DateTime(2024, 3, 15),
//     DateTime(2024, 3, 20),
//   ];
//
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? datePicked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime.now(),
//       lastDate: DateTime(DateTime.now().year, 12, 31),
//       selectableDayPredicate: (DateTime date) {
//         // Disable dates from the _disabledDates list
//         return !_disabledDates.contains(date);
//       },
//     );
//     if (datePicked != null) {
//       var date = DateFormat('dd/MM/yyyy').format(datePicked);
//       _appointmentDate.text = date;
//       setState(() {});
//     }
//   }
//
//   Future<void> _submitForm(List<Map<String, String>> dataList) async {
//     if (_formKey.currentState!.validate()) {
//       // Date time pick
//       var time = TimeOfDay.now();
//       var date = DateTime.now();
//       // convert to int
//       int? numOfPeople = int.tryParse(_noOfPeople.text);
//       // Appointment Post Data
//
//
//
//       Map<String, dynamic> data = {
//         "id":widget.data.id,
//         "appointmentDate":_appointmentDate.text.isNotEmpty ? _appointmentDate.text : widget.data.appointmentDate,
//         "num_of_people":numOfPeople ?? widget.data.numOfPeople ,
//         "pickup": _pickup,
//         "days": _noOfDays.text.isNotEmpty ? _noOfDays.text : widget.data.days,
//         "from": pickupFrom.isEmpty ? "No Data" : pickupFrom,
//         "emergencyNumber": _emergencyContact.text.isNotEmpty ? _emergencyContact.text : widget.data.emergencyNumber,
//         "appointment_time":widget.data.appointmentTime,
//         "appointment_reason": _reason.text.isNotEmpty? _reason.text: widget.data.appointmentReason,
//         "register_date":widget.data.appointmentDate.isNotEmpty? widget.data.appointmentDate: "${date.day}/${date.month}/${date.year}",
//         "groupmembers":dataList
//       };
//       debugPrint(data.toString());
//       //  Api call
//       await Provider.of<AppointmentController>(context, listen: false).updateAppointment(context, data);
//     }
//   }
//
//   List<String> _groupMemberAgeControllers = [];
//   List<String> _groupMemberRelationControllers = [];
//   List<String> _groupMemberControllers = [];
//
//
//   // WidgetTree
//   @override
//   Widget build(BuildContext context) {
//     var pro = Provider.of<AppointmentController>(context);
//     List<Map<String, String>> dataList = [];
// // Iterate through each index
//     const int maxCharacters = 100; // Maximum characters allowed
//     // const int peopleDigitLimit = 1; // Maximum characters allowed
//     const int daysDigitLimit = 2; // Maximum characters allowed
//     debugPrint("rebuild tree");
//     spaceBetween = SizedBox(
//       height: 16.h,
//     );
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: pageBackground,
//         appBar: AppBar(
//           leading: IconButton(
//               onPressed: () {
//                 pro.countOfPeople = 0;
//                 Navigator.pop(context);
//               },
//               icon: Icon(
//                 Icons.arrow_back,
//                 color: pageBackground,
//               )),
//           backgroundColor: appbar,
//           title: Text(
//             "Edit Appointment",
//             style: TextStyle(color: pageBackground),
//           ),
//           // centerTitle: true,
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.fromLTRB(10.sp, 15.sp, 10.sp, 10.sp),
//             child: Form(
//               key: _formKey,
//               child: Container(
//                 child: Column(
//                   children: [
//                     spaceBetween,
//                     spaceBetween,
//                     TextFormField(
//                       style: TextStyle(color: inputText),
//                       onTap: () {
//                         _selectDate(context);
//                       },
//                       // controller: _appointmentDate,
//                       readOnly: true,
//                       keyboardType: TextInputType.datetime,
//                       cursorColor: textFieldOutline,
//                       initialValue: widget.data.appointmentDate,
//                       inputFormatters: [DateTextFormatter()],
//                       decoration: InputDecoration(
//                         prefixIcon: IconButton(
//                           onPressed: () async {
//                             _selectDate(context);
//                           },
//                           icon: Icon(
//                             Icons.calendar_month,
//                             color: iconColor,
//                             size: 20.sp,
//                           ),
//                         ),
//                         label: Text(
//                           appointmentDate,
//                           style: TextStyle(color: placeHolder),
//                         ),
//                         hintText: ddMmYyyy,
//                         labelStyle: TextStyle(
//                           color: placeHolder,
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.normal,
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5),
//                           borderSide: BorderSide(color: textFieldOutline),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5),
//                           borderSide: BorderSide(
//                               color: onSelectTextFieldOutline, width: 2),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please select appointment date';
//                         }
//                         return null;
//                       },
//                     ),
//                     // spaceBetween,
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Checkbox(
//                             side: BorderSide(color: textFieldOutline, width: 2),
//                             activeColor: buttonText,
//                             value: _appointmentForOther,
//                             onChanged: (val) {
//                               setState(() {
//                                 _appointmentForOther = !_appointmentForOther;
//                               });
//                             }),
//                         Expanded(child: Text(appointmentForOther))
//                       ],
//                     ),
//
//                     // spaceBetween,
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Row(
//                           children: [
//                             Text(noOfPeople),
//                             Padding(
//                               padding: EdgeInsets.fromLTRB(8.sp,0.sp,8.sp,0.sp),
//                               child: GestureDetector(
//                                 onTap: () {
//                                   pro.subtract();
//                                   _noOfPeople.text = pro.countOfPeople.toString();
//                                 },
//                                 child: Container(
//                                     color:inputText,
//                                     child:Icon(Icons.remove,color: Colors.white,)
//                                 ),
//                               ),
//                             ),
//                             Text("${pro.countOfPeople.toString()}"),
//                             Padding(
//                               padding: EdgeInsets.fromLTRB(8.sp,0.sp,8.sp,0.sp),
//                               child: GestureDetector(
//                                 onTap: () {
//                                   pro.addCount();
//                                   _noOfPeople.text = pro.countOfPeople.toString();
//                                 },
//                                 child: Container(
//                                     color:pro.countOfPeople != 5? inputText : Colors.grey,
//                                     child: Icon(Icons.add,color:pro.countOfPeople != 5? Colors.white:Colors.grey.shade700,)
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           width: 16.w,
//                         ),
//                         Flexible(
//                           child: TextFormField(
//                             initialValue: widget.data.days,
//                             style: TextStyle(color: inputText),
//                             // controller: _noOfDays,
//                             inputFormatters: [
//                               LengthLimitingTextInputFormatter(daysDigitLimit),
//                             ],
//                             keyboardType: TextInputType.number,
//                             decoration: InputDecoration(
//                               label: Text(
//                                 noOfDays,
//                                 style: TextStyle(color: placeHolder),
//                               ),
//                               labelStyle: TextStyle(
//                                 color: textFieldOutline,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.normal,
//                               ),
//                               suffix: InkWell(
//                                 onTap: () {
//                                   _noOfDays.clear();
//                                 },
//                                 child: Icon(
//                                   Icons.highlight_off_outlined,
//                                   color: iconColor,
//                                 ),
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                                 borderSide: BorderSide(color: textFieldOutline),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                                 borderSide: BorderSide(
//                                     color: onSelectTextFieldOutline, width: 2),
//                               ),
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'No. of days required';
//                               }
//                               // Validate if the entered value is a valid integer
//                               final intValue = int.tryParse(value);
//                               if (intValue == null || intValue <= 0) {
//                                 return 'Valid number please';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                     if (pro.countOfPeople != 0)
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
//                         child: Row(
//                           children: [
//                             Text("Personal Details"),
//                           ],
//                         ),
//                       ),
//                     Container(
//                       height: pro.countOfPeople * 190.0,
//                       // Adjust the height based on the number of items
//                       child: ListView.builder(
//                         physics: NeverScrollableScrollPhysics(),
//                         itemCount: pro.countOfPeople,
//                         itemBuilder: (context, index) {
//                           _groupMemberControllers.addAll([""]);
//                           _groupMemberAgeControllers.addAll([""]);
//                           _groupMemberRelationControllers.addAll([""]);
//                           print("rebuild");
//                           return Padding(
//                             padding: EdgeInsets.only(bottom: 16.0),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: EdgeInsets.only(top: 23.0, right: 10.0),
//                                   child: Text("#${index + 1}"),
//                                 ),
//                                 Expanded(
//                                   child: Column(
//                                     children: [
//                                       TextFormField(
//                                         style: TextStyle(color: inputText),
//                                         // controller: groupMemberControllers[index],
//                                         initialValue: _groupMemberControllers[index],
//                                         decoration: InputDecoration(
//                                           labelText: "Name",
//                                           labelStyle: TextStyle(color: placeHolder),
//                                           suffixIcon: InkWell(
//                                             onTap: () {
//                                               // _groupMemberControllers[index].clear();
//                                             },
//                                             child: Icon(
//                                               Icons.highlight_off_outlined,
//                                               color: iconColor,
//                                             ),
//                                           ),
//                                           border: OutlineInputBorder(
//                                             borderRadius: BorderRadius.circular(5.0),
//                                             borderSide: BorderSide(color: textFieldOutline),
//                                           ),
//                                           focusedBorder: OutlineInputBorder(
//                                             borderRadius: BorderRadius.circular(5.0),
//                                             borderSide: BorderSide(
//                                               color: onSelectTextFieldOutline,
//                                               width: 2.0,
//                                             ),
//                                           ),
//                                         ),
//                                         onChanged: (val) {
//                                           _groupMemberControllers[index] = val;
//
//                                           // Handle onChanged
//                                         },
//                                       ),
//                                       SizedBox(height: 8.0),
//                                       Row(
//                                         children: [
//                                           Expanded(
//                                             child: TextFormField(
//                                               style: TextStyle(color: inputText),
//                                               initialValue: _groupMemberAgeControllers[index],
//                                               // controller: _groupMemberAgeControllers[index],
//                                               decoration: InputDecoration(
//                                                 labelText: "Age",
//                                                 labelStyle: TextStyle(color: placeHolder),
//                                                 suffixIcon: InkWell(
//                                                   onTap: () {
//                                                     // _groupMemberAgeControllers[index].clear();
//                                                   },
//                                                   child: Icon(
//                                                     Icons.highlight_off_outlined,
//                                                     color: iconColor,
//                                                   ),
//                                                 ),
//                                                 border: OutlineInputBorder(
//                                                   borderRadius: BorderRadius.circular(5.0),
//                                                   borderSide: BorderSide(color: textFieldOutline),
//                                                 ),
//                                                 focusedBorder: OutlineInputBorder(
//                                                   borderRadius: BorderRadius.circular(5.0),
//                                                   borderSide: BorderSide(
//                                                     color: onSelectTextFieldOutline,
//                                                     width: 2.0,
//                                                   ),
//                                                 ),
//                                               ),
//                                               onChanged: (val) {
//                                                 _groupMemberAgeControllers[index] = val;
//                                                 // Handle onChanged
//                                               },
//                                             ),
//                                           ),
//                                           SizedBox(width: 16.0),
//                                           Expanded(
//                                             child: TextFormField(
//                                               style: TextStyle(color: inputText),
//                                               // controller: _groupMemberRelationControllers[index],
//                                               initialValue: _groupMemberRelationControllers[index],
//                                               decoration: InputDecoration(
//                                                 labelText: "Relation",
//                                                 labelStyle: TextStyle(color: placeHolder),
//                                                 suffixIcon: InkWell(
//                                                   onTap: () {
//                                                     // _groupMemberRelationControllers[index].clear();
//                                                   },
//                                                   child: Icon(
//                                                     Icons.highlight_off_outlined,
//                                                     color: iconColor,
//                                                   ),
//                                                 ),
//                                                 border: OutlineInputBorder(
//                                                   borderRadius: BorderRadius.circular(5.0),
//                                                   borderSide: BorderSide(color: textFieldOutline),
//                                                 ),
//                                                 focusedBorder: OutlineInputBorder(
//                                                   borderRadius: BorderRadius.circular(5.0),
//                                                   borderSide: BorderSide(
//                                                     color: onSelectTextFieldOutline,
//                                                     width: 2.0,
//                                                   ),
//                                                 ),
//                                               ),
//                                               onChanged: (val) {
//                                                 _groupMemberRelationControllers[index] = val;
//
//                                                 // Handle onChanged
//                                               },
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Checkbox(
//                             side: BorderSide(color: textFieldOutline, width: 2),
//                             activeColor: buttonText,
//                             value: _pickup,
//                             onChanged: (val) {
//                               setState(() {
//                                 _pickup = !_pickup;
//                               });
//                             }),
//                         const Text(pickupCheckbox)
//                       ],
//                     ),
//
//                     if (_pickup == true)
//                       TextFormField(
//                         initialValue: widget.data.from,
//                         style: TextStyle(color: inputText),
//                         // controller: _pickupPoint,
//                         maxLength: maxCharacters,
//                         maxLines: null,
//                         keyboardType: TextInputType.multiline,
//                         decoration: InputDecoration(
//                           label: Text(
//                             pickUpPoint,
//                           ),
//                           labelStyle: TextStyle(
//                               color: placeHolder,
//                               fontSize: 16.sp,
//                               fontWeight: FontWeight.normal),
//                           suffix: InkWell(
//                               onTap: () {
//                                 _pickupPoint.clear();
//                               },
//                               child: Icon(
//                                 Icons.highlight_off_outlined,
//                                 color: iconColor,
//                               )),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(5),
//                             borderSide: BorderSide(color: textFieldOutline),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(5),
//                             borderSide: BorderSide(
//                                 color: onSelectTextFieldOutline, width: 2),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter a Valid Pickup Point';
//                           }
//                           return null;
//                         },
//                         onChanged: (val) {
//                           pickupFrom = val;
//                         },
//                       ),
//                     if (_pickup == true) spaceBetween,
//                     TextFormField(
//                       style: TextStyle(color: inputText),
//                       // controller: _emergencyContact,
//                       initialValue: widget.data.emergencyNumber,
//                       keyboardType: TextInputType.phone,
//                       decoration: InputDecoration(
//                         label: Text(emergencyContact),
//                         labelStyle: TextStyle(
//                             color: placeHolder,
//                             fontSize: 16.sp,
//                             fontWeight: FontWeight.normal),
//                         suffix: InkWell(
//                             onTap: () {
//                               _emergencyContact.clear();
//                             },
//                             child: Icon(
//                               Icons.highlight_off_outlined,
//                               color: iconColor,
//                             )),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5),
//                           borderSide: BorderSide(color: textFieldOutline),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5),
//                           borderSide: BorderSide(
//                               color: onSelectTextFieldOutline, width: 2),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Phone number is required';
//                         }
//                         // Define a regular expression for validating phone numbers
//                         final RegExp phoneRegex = RegExp(r'^\+?[0-9]{7,13}$');
//                         // Allows for optional '+91' country code followed by 7 to 13 digits
//
//                         // Check if the entered value matches the phone number format
//                         if (!phoneRegex.hasMatch(value)) {
//                           return 'Enter a valid phone number';
//                         }
//                         return null;
//                       },
//                     ),
//                     spaceBetween,
//                     TextFormField(
//                       style: TextStyle(color: inputText),
//                       // controller: _reason,
//                       initialValue: widget.data.appointmentReason,
//                       maxLength: maxCharacters,
//                       maxLines: null,
//                       keyboardType: TextInputType.multiline,
//                       decoration: InputDecoration(
//                         label: Text(
//                           remark,
//                         ),
//                         labelStyle: TextStyle(
//                           color: placeHolder,
//                           fontSize: 16,
//                           fontWeight: FontWeight.normal,
//                         ),
//                         suffix: InkWell(
//                           onTap: () {
//                             _reason.clear();
//                           },
//                           child: Icon(
//                             Icons.highlight_off_outlined,
//                             color: iconColor,
//                           ),
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5),
//                           borderSide: BorderSide(color: textFieldOutline),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(5),
//                           borderSide: BorderSide(
//                               color: onSelectTextFieldOutline, width: 2),
//                         ),
//                       ),
//                     ),
//                     spaceBetween,
//                     Row(
//                       children: [
//                         Checkbox(
//                           activeColor: inputText,
//                           value: _termsAndCondition,
//                           onChanged: (value) {
//                             _termsAndCondition = !_termsAndCondition;
//                             setState(() {});
//                           },
//                         ),
//                         Expanded(
//                           child: RichText(
//                             text: TextSpan(
//                               children: [
//                                 TextSpan(
//                                   text:
//                                   "I hereby acknowledge that I have read and accept the ",
//                                   style:
//                                   TextStyle(fontSize: 14, color: inputText),
//                                 ),
//                                 TextSpan(
//                                   text: "Terms and conditions ",
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       color: buttonColor,
//                                       fontWeight: FontWeight.bold),
//                                   recognizer: TapGestureRecognizer()
//                                     ..onTap = () {
//                                       Navigator.push(
//                                         context,
//                                         PageRouteBuilder(
//                                           transitionDuration:
//                                           Duration(milliseconds: 500),
//                                           transitionsBuilder: (BuildContext
//                                           context,
//                                               Animation<double> animation,
//                                               Animation<double> secAnimation,
//                                               Widget child) {
//                                             return SlideTransition(
//                                               position: Tween<Offset>(
//                                                 begin: Offset(1.0, 0.0),
//                                                 end: Offset.zero,
//                                               ).animate(animation),
//                                               child: child,
//                                             );
//                                           },
//                                           pageBuilder: (BuildContext context,
//                                               Animation<double> animation,
//                                               Animation<double> secAnimation) {
//                                             return TermsAndConditions();
//                                           },
//                                         ),
//                                       );
//                                       // Add your code here to handle tap
//                                       // print("Terms and conditions tapped!");
//                                     },
//                                 ),
//                                 TextSpan(
//                                   text: "governing appointments.",
//                                   style:
//                                   TextStyle(fontSize: 14, color: inputText),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//
//                     SizedBox(
//                       height: 36.h,
//                     ),
//                     SizedBox(
//                       height: 56.sp,
//                       child: ElevatedButton(
//                         onPressed: _termsAndCondition != true? null : () async {
//                           for (int i = 0; i < pro.countOfPeople; i++) {
//                             // Create a map to store data for each index
//                             for (GroupMember member in widget.data.groupMembers) {
//                               int memberId = member.id;
//                               // Now you can use memberId as needed
//                               print("Group Member ID: $memberId");
//                               Map<String, String> dataMap = {
//                                 "id":memberId.toString(),
//                                 'name': _groupMemberControllers[i],
//                                 'age': _groupMemberAgeControllers[i],
//                                 'relation': _groupMemberRelationControllers[i],
//                               };
//                               // Add the map to the list
//                               dataList.add(dataMap);
//                             }
//                             print(dataList.toString());
//                             await _submitForm(dataList);
//                             await Provider.of<AppointmentController>(context, listen: false).fetchAppointments();
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           shadowColor: Colors.black,
//                           // Customize the shadow color
//                           elevation: 4,
//                           // Adjust the elevation for the shadow
//                           // Customize the background color
//                           primary:
//                           buttonColor,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(
//                                 16), // Adjust the radius as needed
//                           ), // Example color, change it according to your preference
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                                 Icons.check,
//                                 color:  _termsAndCondition == true
//                                     ? buttonText
//                                     : Colors.white
//                             ),
//                             Text(
//                               confirmBooking,
//                               style: TextStyle(
//                                   color: _termsAndCondition == true
//                                       ? buttonText
//                                       : Colors.white),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     spaceBetween,
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/models/appointment_model.dart';
import 'package:thusmai_appointmrent/pages/appointment/termsandconditions.dart';
import '../../constant/constant.dart'; // Assuming this file contains the 'appTheam' constant
import 'package:flutter/material.dart';
import '../../controller/appointmentontroller.dart';
import '../../models/appointment_add_model.dart';
import '../../widgets/additionnalwidget.dart';

class AppointmentAddPage extends StatefulWidget {
  const AppointmentAddPage({Key? key}) : super(key: key);

  @override
  State<AppointmentAddPage> createState() => _AppointmentAddPageState();
}

class _AppointmentAddPageState extends State<AppointmentAddPage> {
  // Variables
  String pickupFrom = "";
  bool _pickup = false;
  bool _externalUser = false;
  bool _termsAndCondition = false;
  bool _internalUser = false;
  String? selectedValue = "No";

  // bool PersonalDetailExpand = false;

  // validation Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // text Controllers
  final TextEditingController _appointmentDate = TextEditingController();
  final TextEditingController _noOfDays = TextEditingController();
  final TextEditingController _noOfPeople = TextEditingController();
  final TextEditingController _pickupPoint = TextEditingController();
  final TextEditingController _emergencyContact = TextEditingController();
  final TextEditingController _reason = TextEditingController();

  List<TextEditingController> _GroupMembersDataAgeControllers = [];
  List<TextEditingController> _GroupMembersDataRelationControllers = [];
  List<TextEditingController> _GroupMembersDataControllers = [];

  // Define a list to store the expansion state of each item
  List<bool> itemExpandedList = [];

  // init State
  @override
  void initState() {
    super.initState();
  }

  // dispose controllers
  @override
  void dispose() {
    _appointmentDate.dispose();
    _noOfDays.dispose();
    _noOfPeople.dispose();
    _pickupPoint.dispose();
    _emergencyContact.dispose();
    _reason.dispose();
    for (var controller in _GroupMembersDataControllers) {
      controller.dispose();
    }
    for (var controller in _GroupMembersDataAgeControllers) {
      controller.dispose();
    }
    for (var controller in _GroupMembersDataRelationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // disabledDates from Operator

  final List<DateTime> _disabledDates = [
    DateTime(2024, 3, 10),
    DateTime(2024, 3, 15),
    DateTime(2024, 3, 18),
  ];

  Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();

    // Check if the selected date is disabled
    if (_disabledDates.contains(selectedDate)) {
      // If selected date is disabled, find the next available date
      selectedDate = selectedDate.add(const Duration(days: 1));
      while (_disabledDates.contains(selectedDate)) {
        selectedDate = selectedDate.add(const Duration(days: 1));
      }
    }

    final DateTime? datePicked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1, 12, 31),
      // Add one more year
      selectableDayPredicate: selectableDayPredicate,
    );
    if (datePicked != null) {
      var date = DateFormat('dd/MM/yyyy').format(datePicked);
      _appointmentDate.text = date;
      setState(() {});
    }
  }

// Define the selectableDayPredicate outside _selectDate
  bool selectableDayPredicate(DateTime date) {
    // Disable dates from the _disabledDates list
    return !_disabledDates.contains(date);
  }

  // Submit data For Appointment
  Future<void> _submitForm(List<GroupMemberAdd> dataList) async {
    // Date time pick
    String time = DateFormat('hh:mm a').format(DateTime.now());
    var date = DateFormat('dd/MM/yyyy').format(DateTime.now());

    // convert numOfPeople to int
    int? numOfPeople = int.tryParse(_noOfPeople.text);

    // Appointment Post Data
    AppointmentAddData data = AppointmentAddData(
      appointmentDate: _appointmentDate.text,
      numOfPeople: numOfPeople,
      pickup: _pickup,
      days: _noOfDays.text,
      from: pickupFrom.isEmpty ? "N/A" : pickupFrom,
      emergencyNumber: _emergencyContact.text,
      appointmentTime: time,
      appointmentReason: _reason.text,
      registerDate: date,
      groupMembers: dataList,
      externalUser: _externalUser,
    );
    await Provider.of<AppointmentController>(context, listen: false)
        .postAppointment(context, data);
  }

  // WidgetTree
  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<AppointmentController>(context);
    List<GroupMemberAdd> dataList = [];
// Iterate through each index
    const int maxCharacters = 100; // Maximum characters allowed
    // const int peopleDigitLimit = 1; // Maximum characters allowed
    const int daysDigitLimit = 2; // Maximum characters allowed
    spaceBetween = SizedBox(
      height: 16.h,
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: shadeOne,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                pro.countOfPeople = 0;
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: shadeOne,
              )),
          backgroundColor: darkShade,
          title: Text(
            bookAppointment,
            style: TextStyle(color: shadeOne),
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
                      style: TextStyle(color: darkShade),
                      onTap: () {
                        _selectDate(context);
                      },
                      controller: _appointmentDate,
                      readOnly: true,
                      keyboardType: TextInputType.datetime,
                      cursorColor: shadeNine,
                      inputFormatters: [DateTextFormatter()],
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                          onPressed: () async {
                            _selectDate(context);
                          },
                          icon: Icon(
                            Icons.calendar_month,
                            color: shadeTen,
                            size: 20.sp,
                          ),
                        ),
                        label: Text(
                          appointmentDate,
                          style: TextStyle(color: shadeTen),
                        ),
                        hintText: ddMmYyyy,
                        labelStyle: TextStyle(
                          color: shadeTen,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.normal,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: shadeNine),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: darkShade, width: 2),
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Are you attending ?")),
                        Row(
                          children: [
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'Yes',
                                  groupValue: selectedValue,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValue = value;
                                      _externalUser = true;
                                    });
                                  },
                                ),
                              ],
                            ),
                            Text("Yes"),
                            Radio<String>(
                              value: 'No',
                              groupValue: selectedValue,
                              onChanged: (value) {
                                setState(() {
                                  selectedValue = value;
                                  _externalUser = false;
                                });
                              },
                            ),
                            Text("No")
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(noOfPeople),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(8.sp, 0.sp, 8.sp, 0.sp),
                              child: GestureDetector(
                                onTap: () {
                                  pro.subtract();
                                  // You also need to decrement the countOfPeople variable if needed
                                  if (pro.countOfPeople < 0) {
                                    pro.countOfPeople--;
                                    pro.countOfPeople = 0;
                                  }
                                  itemExpandedList.removeAt(pro.countOfPeople);
                                  _noOfPeople.text =
                                      pro.countOfPeople.toString();
                                  _GroupMembersDataControllers.removeAt(
                                      pro.countOfPeople);
                                  _GroupMembersDataAgeControllers.removeAt(
                                      pro.countOfPeople);
                                  _GroupMembersDataRelationControllers.removeAt(
                                      pro.countOfPeople);
                                },
                                child: Container(
                                    color: darkShade,
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                            Text("${pro.countOfPeople}"),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(8.sp, 0.sp, 8.sp, 0.sp),
                              child: GestureDetector(
                                onTap: () {
                                  pro.addCount();
                                  // Set all existing items to true
                                  itemExpandedList.forEach((element) {
                                    element = true;
                                  });
                                  itemExpandedList.add(false);
                                  print(itemExpandedList.toString());
                                  _noOfPeople.text =
                                      pro.countOfPeople.toString();
                                },
                                child: Container(
                                    color: pro.countOfPeople != 5
                                        ? darkShade
                                        : Colors.grey,
                                    child: Icon(
                                      Icons.add,
                                      color: pro.countOfPeople != 5
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                    )),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 16.w,
                        ),
                        Flexible(
                          child: TextFormField(
                            style: TextStyle(color: darkShade),
                            controller: _noOfDays,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(daysDigitLimit),
                            ],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              label: Text(
                                noOfDays,
                                style: TextStyle(color: shadeTen),
                              ),
                              labelStyle: TextStyle(
                                color: shadeNine,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                              suffix: InkWell(
                                onTap: () {
                                  _noOfDays.clear();
                                },
                                child: Icon(
                                  Icons.highlight_off_outlined,
                                  color: shadeTen,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(color: shadeNine),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    BorderSide(color: darkShade, width: 2),
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
                    if (pro.countOfPeople != 0)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                        child: Row(
                          children: [
                            Text("Personal Details"),
                          ],
                        ),
                      ),
                    SizedBox(
                      height: calculateTotalHeight(itemExpandedList),
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: pro.countOfPeople,
                        itemBuilder: (context, index) {
                          _GroupMembersDataControllers.add(
                              TextEditingController());
                          _GroupMembersDataAgeControllers.add(
                              TextEditingController());
                          _GroupMembersDataRelationControllers.add(
                              TextEditingController());
                          return Column(
                            children: [
                              if (!itemExpandedList[index])
                                Padding(
                                  padding: EdgeInsets.only(bottom: 16.sp),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 23, right: 10),
                                        child: Text("#${index + 1}"),
                                      ),
                                      Expanded(
                                        child: Container(
                                          // height: 258.h,
                                          decoration: BoxDecoration(
                                            color: shadeTwo,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  style: TextStyle(
                                                      color: darkShade),
                                                  controller:
                                                      _GroupMembersDataControllers[
                                                          index],
                                                  decoration: InputDecoration(
                                                    labelText: "Name",
                                                    labelStyle: TextStyle(
                                                        color: shadeTen),
                                                    suffixIcon: InkWell(
                                                      onTap: () {
                                                        _GroupMembersDataControllers[
                                                                index]
                                                            .clear();
                                                      },
                                                      child: Icon(
                                                        Icons
                                                            .highlight_off_outlined,
                                                        color: shadeTen,
                                                      ),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      borderSide: BorderSide(
                                                          color: shadeNine),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      borderSide: BorderSide(
                                                        color: darkShade,
                                                        width: 2,
                                                      ),
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
                                                        inputFormatters: [
                                                          LengthLimitingTextInputFormatter(
                                                              daysDigitLimit),
                                                        ],
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        style: TextStyle(
                                                            color: darkShade),
                                                        controller:
                                                            _GroupMembersDataAgeControllers[
                                                                index],
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: "Age",
                                                          labelStyle: TextStyle(
                                                              color: shadeTen),
                                                          suffixIcon: InkWell(
                                                            onTap: () {
                                                              _GroupMembersDataAgeControllers[
                                                                      index]
                                                                  .clear();
                                                            },
                                                            child: Icon(
                                                              Icons
                                                                  .highlight_off_outlined,
                                                              color: shadeTen,
                                                            ),
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            borderSide: BorderSide(
                                                                color:
                                                                    shadeNine),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            borderSide:
                                                                BorderSide(
                                                              color: darkShade,
                                                              width: 2,
                                                            ),
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
                                                        style: TextStyle(
                                                            color: darkShade),
                                                        controller:
                                                            _GroupMembersDataRelationControllers[
                                                                index],
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: "Relation",
                                                          labelStyle: TextStyle(
                                                              color: shadeTen),
                                                          suffixIcon: InkWell(
                                                            onTap: () {
                                                              _GroupMembersDataRelationControllers[
                                                                      index]
                                                                  .clear();
                                                            },
                                                            child: Icon(
                                                              Icons
                                                                  .highlight_off_outlined,
                                                              color: shadeTen,
                                                            ),
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            borderSide: BorderSide(
                                                                color:
                                                                    shadeNine),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            borderSide:
                                                                BorderSide(
                                                              color: darkShade,
                                                              width: 2,
                                                            ),
                                                          ),
                                                        ),
                                                        onChanged: (val) {
                                                          // Handle onChanged
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      5.sp, 16.sp, 5.sp, 5.sp),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          shadowColor:
                                                              Colors.black,
                                                          elevation: 4,
                                                          primary: darkShade,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          _GroupMembersDataControllers[
                                                                  index]
                                                              .clear();
                                                          _GroupMembersDataAgeControllers[
                                                                  index]
                                                              .clear();
                                                          _GroupMembersDataRelationControllers[
                                                                  index]
                                                              .clear();
                                                        },
                                                        child: Text(
                                                          "Clear",
                                                          style: TextStyle(
                                                              color: shadeTwo),
                                                        ),
                                                      ),
                                                      SizedBox(width: 16.w),
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          shadowColor:
                                                              Colors.black,
                                                          elevation: 4,
                                                          primary: darkShade,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          itemExpandedList[
                                                              index] = true;
                                                          setState(() {});
                                                        },
                                                        child: Text(
                                                          "Save",
                                                          style: TextStyle(
                                                              color: shadeTwo),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (itemExpandedList[index])
                                Padding(
                                  padding: EdgeInsets.only(bottom: 16.sp),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Text("#${index + 1}"),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              itemExpandedList[index] = false;
                                              setState(() {});
                                            },
                                            child: Container(
                                              height: 56.h,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: shadeTwo),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8),
                                                    child: Text(
                                                        "${_GroupMembersDataControllers[index].text},"),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8),
                                                    child: Text(
                                                        "${_GroupMembersDataAgeControllers[index].text},"),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8),
                                                    child: Text(
                                                        "${_GroupMembersDataRelationControllers[index].text}"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                // // // Remove the item at the given index from each TextEditingController list
                                                _GroupMembersDataControllers
                                                    .removeAt(index);
                                                _GroupMembersDataAgeControllers
                                                    .removeAt(index);
                                                _GroupMembersDataRelationControllers
                                                    .removeAt(index);
                                                // // You also need to decrement the countOfPeople variable if needed
                                                pro.countOfPeople -= 1;
                                                itemExpandedList
                                                    .removeAt(index);
                                                calculateTotalHeight(
                                                    itemExpandedList);
                                              });
                                            },
                                            icon: Icon(
                                                Icons.highlight_off_outlined))
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                            side: BorderSide(color: shadeNine, width: 2),
                            activeColor: brown,
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
                        style: TextStyle(color: darkShade),
                        controller: _pickupPoint,
                        maxLength: maxCharacters,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          label: Text(
                            pickUpPoint,
                          ),
                          labelStyle: TextStyle(
                              color: shadeTen,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.normal),
                          suffix: InkWell(
                              onTap: () {
                                _pickupPoint.clear();
                              },
                              child: Icon(
                                Icons.highlight_off_outlined,
                                color: shadeTen,
                              )),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: shadeNine),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: darkShade, width: 2),
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
                      style: TextStyle(color: darkShade),
                      controller: _emergencyContact,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        label: Text(emergencyContact),
                        labelStyle: TextStyle(
                            color: shadeTen,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.normal),
                        suffix: InkWell(
                            onTap: () {
                              _emergencyContact.clear();
                            },
                            child: Icon(
                              Icons.highlight_off_outlined,
                              color: shadeTen,
                            )),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: shadeNine),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: darkShade, width: 2),
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
                      style: TextStyle(color: darkShade),
                      controller: _reason,
                      maxLength: maxCharacters,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        label: Text(
                          remark,
                        ),
                        labelStyle: TextStyle(
                          color: shadeTen,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                        suffix: InkWell(
                          onTap: () {
                            _reason.clear();
                          },
                          child: Icon(
                            Icons.highlight_off_outlined,
                            color: shadeTen,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: shadeNine),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: darkShade, width: 2),
                        ),
                      ),
                    ),
                    spaceBetween,
                    Row(
                      children: [
                        Checkbox(
                          activeColor: darkShade,
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
                                      TextStyle(fontSize: 14, color: darkShade),
                                ),
                                TextSpan(
                                  text: "Terms and conditions ",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: goldShade,
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      slidePageRoute(context,TermsAndConditions());
                                      // Add your code here to handle tap
                                      // print("Terms and conditions tapped!");
                                    },
                                ),
                                TextSpan(
                                  text: "governing appointments.",
                                  style:
                                      TextStyle(fontSize: 14, color: darkShade),
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
                        onPressed: _termsAndCondition != true
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  for (int i = 0; i < pro.countOfPeople; i++) {
                                    // Create a map to store data for each index
                                    GroupMemberAdd dataMap = GroupMemberAdd(
                                      name:
                                          _GroupMembersDataControllers[i].text,
                                      age: _GroupMembersDataAgeControllers[i]
                                          .text,
                                      relation:
                                          _GroupMembersDataRelationControllers[
                                                  i]
                                              .text,
                                    );
                                    // Add the map to the list
                                    dataList.add(dataMap);
                                  }
                                  await _submitForm(dataList);
                                  itemExpandedList.clear();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.black,
                          // Customize the shadow color
                          elevation: 4,
                          primary: goldShade,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                16), // Adjust the radius as needed
                          ), // Example color, change it according to your preference
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check,
                                color: _termsAndCondition == true
                                    ? brown
                                    : Colors.grey),
                            Text(
                              confirmBooking,
                              style: TextStyle(
                                  color: _termsAndCondition == true
                                      ? brown
                                      : Colors.grey),
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

  double calculateTotalHeight(List<bool> itemExpandedList) {
    double trueCount = 0;
    double falseCount = 0;

    // Iterate through the list and count the number of true and false values
    for (bool itemExpanded in itemExpandedList) {
      if (itemExpanded) {
        trueCount++;
      } else {
        falseCount++;
      }
    }
    // Calculate the total height
    double totalHeight = (trueCount * 80.h) + (falseCount * 280.h);
    return totalHeight;
  }
}
