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
import '../../controller/login_register_otp_api.dart';
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
  // bool _internalUser = false;
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
  List<DateTime> disabledDates = [];

  // init State
  @override
  void initState() {
    super.initState();
    Provider.of<AppLogin>(context,listen: false).importantFlags();
    // Provider.of<AppointmentController>(context,listen: false).disableDates();
     disabledDates = Provider.of<AppointmentController>(context,listen: false).disabledDates;

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
  //
  // final List<DateTime> _disabledDates = [
  //   // DateTime(2024, 6, 4),
  //   // DateTime(2024, 6, 8),
  //   // DateTime(2024, 6, 19),
  // ];

  Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();

    // Check if the selected date is disabled
    if (disabledDates.contains(selectedDate)) {
      // If selected date is disabled, find the next available date
      selectedDate = selectedDate.add(const Duration(days: 1));
      while (disabledDates.contains(selectedDate)) {
        selectedDate = selectedDate.add(const Duration(days: 1));
      }
    }

    final DateTime? datePicked = await showDatePicker(
      context: context,
      // initialDate: selectedDate,
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
    return !disabledDates.contains(date);
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

    var appointmentController = Provider.of<AppointmentController>(context);
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
                appointmentController.countOfPeople = 0;
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
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     Align(
                    //         alignment: Alignment.centerLeft,
                    //         child: Text("Are you attending ?")),
                    //     Row(
                    //       children: [
                    //         Row(
                    //           children: [
                    //             Radio<String>(
                    //               value: 'Yes',
                    //               groupValue: selectedValue,
                    //               onChanged: (value) {
                    //                 setState(() {
                    //                   selectedValue = value;
                    //                   _externalUser = true;
                    //                 });
                    //               },
                    //             ),
                    //           ],
                    //         ),
                    //         Text("Yes"),
                    //         Radio<String>(
                    //           value: 'No',
                    //           groupValue: selectedValue,
                    //           onChanged: (value) {
                    //             setState(() {
                    //               selectedValue = value;
                    //               _externalUser = false;
                    //             });
                    //           },
                    //         ),
                    //         Text("No")
                    //       ],
                    //     ),
                    //   ],
                    // ),
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
                                  appointmentController.subtract();
                                  // You also need to decrement the countOfPeople variable if needed
                                  if (appointmentController.countOfPeople < 0) {
                                    appointmentController.countOfPeople--;
                                    appointmentController.countOfPeople = 0;
                                  }
                                  itemExpandedList.removeAt(appointmentController.countOfPeople);
                                  _noOfPeople.text =
                                      appointmentController.countOfPeople.toString();
                                  _GroupMembersDataControllers.removeAt(
                                      appointmentController.countOfPeople);
                                  _GroupMembersDataAgeControllers.removeAt(
                                      appointmentController.countOfPeople);
                                  _GroupMembersDataRelationControllers.removeAt(
                                      appointmentController.countOfPeople);
                                },
                                child: Container(
                                    color: darkShade,
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                            Text("${appointmentController.countOfPeople}"),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(8.sp, 0.sp, 8.sp, 0.sp),
                              child: GestureDetector(
                                onTap: () {
                                  appointmentController.addCount();
                                  // Set all existing items to true
                                  itemExpandedList.forEach((element) {
                                    element = true;
                                  });
                                  itemExpandedList.add(false);
                                  print(itemExpandedList.toString());
                                  _noOfPeople.text =
                                      appointmentController.countOfPeople.toString();
                                },
                                child: Container(
                                    color: appointmentController.countOfPeople != 5
                                        ? darkShade
                                        : Colors.grey,
                                    child: Icon(
                                      Icons.add,
                                      color: appointmentController.countOfPeople != 5
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
                    if (appointmentController.countOfPeople != 0)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                        child: Row(
                          children: [
                            Text("Personal Details"),
                          ],
                        ),
                      ),
                    // SizedBox(
                    //   height: calculateTotalHeight(itemExpandedList),
                    //   child: ListView.builder(
                    //     physics: NeverScrollableScrollPhysics(),
                    //     itemCount: pro.countOfPeople,
                    //     itemBuilder: (context, index) {
                    //       _GroupMembersDataControllers.add(
                    //           TextEditingController());
                    //       _GroupMembersDataAgeControllers.add(
                    //           TextEditingController());
                    //       _GroupMembersDataRelationControllers.add(
                    //           TextEditingController());
                    //       return Column(
                    //         children: [
                    //           if (!itemExpandedList[index])
                    //             Padding(
                    //               padding: EdgeInsets.only(bottom: 16.sp),
                    //               child: Row(
                    //                 crossAxisAlignment:
                    //                     CrossAxisAlignment.start,
                    //                 children: [
                    //                   Padding(
                    //                     padding: EdgeInsets.only(
                    //                         top: 23, right: 10),
                    //                     child: Text("#${index + 1}"),
                    //                   ),
                    //                   Expanded(
                    //                     child: Container(
                    //                       // height: 258.h,
                    //                       decoration: BoxDecoration(
                    //                         color: shadeTwo,
                    //                         borderRadius:
                    //                             BorderRadius.circular(8),
                    //                       ),
                    //                       child: Padding(
                    //                         padding: const EdgeInsets.all(8),
                    //                         child: Column(
                    //                           children: [
                    //                             TextFormField(
                    //                               style: TextStyle(
                    //                                   color: darkShade),
                    //                               controller:
                    //                                   _GroupMembersDataControllers[
                    //                                       index],
                    //                               decoration: InputDecoration(
                    //                                 labelText: "Name",
                    //                                 labelStyle: TextStyle(
                    //                                     color: shadeTen),
                    //                                 suffixIcon: InkWell(
                    //                                   onTap: () {
                    //                                     _GroupMembersDataControllers[
                    //                                             index]
                    //                                         .clear();
                    //                                   },
                    //                                   child: Icon(
                    //                                     Icons
                    //                                         .highlight_off_outlined,
                    //                                     color: shadeTen,
                    //                                   ),
                    //                                 ),
                    //                                 border: OutlineInputBorder(
                    //                                   borderRadius:
                    //                                       BorderRadius.circular(
                    //                                           5),
                    //                                   borderSide: BorderSide(
                    //                                       color: shadeNine),
                    //                                 ),
                    //                                 focusedBorder:
                    //                                     OutlineInputBorder(
                    //                                   borderRadius:
                    //                                       BorderRadius.circular(
                    //                                           5),
                    //                                   borderSide: BorderSide(
                    //                                     color: darkShade,
                    //                                     width: 2,
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                               onChanged: (val) {
                    //                                 // Handle onChanged
                    //                               },
                    //                             ),
                    //                             spaceBetween,
                    //                             Row(
                    //                               children: [
                    //                                 Expanded(
                    //                                   child: TextFormField(
                    //                                     inputFormatters: [
                    //                                       LengthLimitingTextInputFormatter(
                    //                                           daysDigitLimit),
                    //                                     ],
                    //                                     keyboardType:
                    //                                         TextInputType
                    //                                             .number,
                    //                                     style: TextStyle(
                    //                                         color: darkShade),
                    //                                     controller:
                    //                                         _GroupMembersDataAgeControllers[
                    //                                             index],
                    //                                     decoration:
                    //                                         InputDecoration(
                    //                                       labelText: "Age",
                    //                                       labelStyle: TextStyle(
                    //                                           color: shadeTen),
                    //                                       suffixIcon: InkWell(
                    //                                         onTap: () {
                    //                                           _GroupMembersDataAgeControllers[
                    //                                                   index]
                    //                                               .clear();
                    //                                         },
                    //                                         child: Icon(
                    //                                           Icons
                    //                                               .highlight_off_outlined,
                    //                                           color: shadeTen,
                    //                                         ),
                    //                                       ),
                    //                                       border:
                    //                                           OutlineInputBorder(
                    //                                         borderRadius:
                    //                                             BorderRadius
                    //                                                 .circular(
                    //                                                     5),
                    //                                         borderSide: BorderSide(
                    //                                             color:
                    //                                                 shadeNine),
                    //                                       ),
                    //                                       focusedBorder:
                    //                                           OutlineInputBorder(
                    //                                         borderRadius:
                    //                                             BorderRadius
                    //                                                 .circular(
                    //                                                     5),
                    //                                         borderSide:
                    //                                             BorderSide(
                    //                                           color: darkShade,
                    //                                           width: 2,
                    //                                         ),
                    //                                       ),
                    //                                     ),
                    //                                     onChanged: (val) {
                    //                                       // Handle onChanged
                    //                                     },
                    //                                   ),
                    //                                 ),
                    //                                 SizedBox(width: 16.sp),
                    //                                 Expanded(
                    //                                   child: TextFormField(
                    //                                     style: TextStyle(
                    //                                         color: darkShade),
                    //                                     controller:
                    //                                         _GroupMembersDataRelationControllers[
                    //                                             index],
                    //                                     decoration:
                    //                                         InputDecoration(
                    //                                       labelText: "Relation",
                    //                                       labelStyle: TextStyle(
                    //                                           color: shadeTen),
                    //                                       suffixIcon: InkWell(
                    //                                         onTap: () {
                    //                                           _GroupMembersDataRelationControllers[
                    //                                                   index]
                    //                                               .clear();
                    //                                         },
                    //                                         child: Icon(
                    //                                           Icons
                    //                                               .highlight_off_outlined,
                    //                                           color: shadeTen,
                    //                                         ),
                    //                                       ),
                    //                                       border:
                    //                                           OutlineInputBorder(
                    //                                         borderRadius:
                    //                                             BorderRadius
                    //                                                 .circular(
                    //                                                     5),
                    //                                         borderSide: BorderSide(
                    //                                             color:
                    //                                                 shadeNine),
                    //                                       ),
                    //                                       focusedBorder:
                    //                                           OutlineInputBorder(
                    //                                         borderRadius:
                    //                                             BorderRadius
                    //                                                 .circular(
                    //                                                     5),
                    //                                         borderSide:
                    //                                             BorderSide(
                    //                                           color: darkShade,
                    //                                           width: 2,
                    //                                         ),
                    //                                       ),
                    //                                     ),
                    //                                     onChanged: (val) {
                    //                                       // Handle onChanged
                    //                                     },
                    //                                   ),
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                             Padding(
                    //                               padding: EdgeInsets.fromLTRB(
                    //                                   5.sp, 16.sp, 5.sp, 5.sp),
                    //                               child: Row(
                    //                                 mainAxisAlignment:
                    //                                     MainAxisAlignment.end,
                    //                                 children: [
                    //                                   ElevatedButton(
                    //                                     style: ElevatedButton
                    //                                         .styleFrom(
                    //                                       shadowColor:
                    //                                           Colors.black, backgroundColor: darkShade,
                    //                                       elevation: 4,
                    //                                       shape:
                    //                                           RoundedRectangleBorder(
                    //                                         borderRadius:
                    //                                             BorderRadius
                    //                                                 .circular(
                    //                                                     100),
                    //                                       ),
                    //                                     ),
                    //                                     onPressed: () {
                    //                                       _GroupMembersDataControllers[
                    //                                               index]
                    //                                           .clear();
                    //                                       _GroupMembersDataAgeControllers[
                    //                                               index]
                    //                                           .clear();
                    //                                       _GroupMembersDataRelationControllers[
                    //                                               index]
                    //                                           .clear();
                    //                                     },
                    //                                     child: Text(
                    //                                       "Clear",
                    //                                       style: TextStyle(
                    //                                           color: shadeTwo),
                    //                                     ),
                    //                                   ),
                    //                                   SizedBox(width: 16.w),
                    //                                   ElevatedButton(
                    //                                     style: ElevatedButton
                    //                                         .styleFrom(
                    //                                       shadowColor:
                    //                                           Colors.black, backgroundColor: darkShade,
                    //                                       elevation: 4,
                    //                                       shape:
                    //                                           RoundedRectangleBorder(
                    //                                         borderRadius:
                    //                                             BorderRadius
                    //                                                 .circular(
                    //                                                     100),
                    //                                       ),
                    //                                     ),
                    //                                     onPressed: () {
                    //                                       itemExpandedList[
                    //                                           index] = true;
                    //                                       setState(() {});
                    //                                     },
                    //                                     child: Text(
                    //                                       "Save",
                    //                                       style: TextStyle(
                    //                                           color: shadeTwo),
                    //                                     ),
                    //                                   ),
                    //                                 ],
                    //                               ),
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           if (itemExpandedList[index])
                    //             Padding(
                    //               padding: EdgeInsets.only(bottom: 16.sp),
                    //               child: Padding(
                    //                 padding: const EdgeInsets.only(top: 8),
                    //                 child: Row(
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.center,
                    //                   children: [
                    //                     Padding(
                    //                       padding: const EdgeInsets.all(4),
                    //                       child: Text("#${index + 1}"),
                    //                     ),
                    //                     Expanded(
                    //                       child: GestureDetector(
                    //                         onTap: () {
                    //                           itemExpandedList[index] = false;
                    //                           setState(() {});
                    //                         },
                    //                         child: Container(
                    //                           height: 56.h,
                    //                           decoration: BoxDecoration(
                    //                               borderRadius:
                    //                                   BorderRadius.circular(8),
                    //                               color: shadeTwo),
                    //                           child: Row(
                    //                             children: [
                    //                               Padding(
                    //                                 padding:
                    //                                     const EdgeInsets.only(
                    //                                         left: 8),
                    //                                 child: Text(
                    //                                     "${_GroupMembersDataControllers[index].text},"),
                    //                               ),
                    //                               Padding(
                    //                                 padding:
                    //                                     const EdgeInsets.only(
                    //                                         left: 8),
                    //                                 child: Text(
                    //                                     "${_GroupMembersDataAgeControllers[index].text},"),
                    //                               ),
                    //                               Padding(
                    //                                 padding:
                    //                                     const EdgeInsets.only(
                    //                                         left: 8),
                    //                                 child: Text(
                    //                                     "${_GroupMembersDataRelationControllers[index].text}"),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ),
                    //                       ),
                    //                     ),
                    //                     IconButton(
                    //                         onPressed: () {
                    //                           setState(() {
                    //                             // // // Remove the item at the given index from each TextEditingController list
                    //                             _GroupMembersDataControllers
                    //                                 .removeAt(index);
                    //                             _GroupMembersDataAgeControllers
                    //                                 .removeAt(index);
                    //                             _GroupMembersDataRelationControllers
                    //                                 .removeAt(index);
                    //                             // // You also need to decrement the countOfPeople variable if needed
                    //                             pro.countOfPeople -= 1;
                    //                             itemExpandedList
                    //                                 .removeAt(index);
                    //                             calculateTotalHeight(
                    //                                 itemExpandedList);
                    //                           });
                    //                         },
                    //                         icon: Icon(
                    //                             Icons.highlight_off_outlined))
                    //                   ],
                    //                 ),
                    //               ),
                    //             ),
                    //         ],
                    //       );
                    //     },
                    //   ),
                    // ),
                    SizedBox(
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: appointmentController.countOfPeople,
                        shrinkWrap: true,
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
                                                              Colors.black, backgroundColor: darkShade,
                                                          elevation: 4,
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
                                                              Colors.black, backgroundColor: darkShade,
                                                          elevation: 4,
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
                                                appointmentController.countOfPeople -= 1;
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
                                      slidePageRoute(
                                          context, TermsAndConditions());
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
                          if(appointmentController.countOfPeople != 0){
                            if (_formKey.currentState!.validate()) {
                              for (int i = 0; i < appointmentController.countOfPeople; i++) {
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
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("The number of people cannot be zero."),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }

                              },
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.black, backgroundColor: goldShade,
                          // Customize the shadow color
                          elevation: 4,
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
