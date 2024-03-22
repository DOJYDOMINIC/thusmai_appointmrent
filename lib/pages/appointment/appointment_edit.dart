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

class AppointmentEditPage extends StatefulWidget {
  const AppointmentEditPage({super.key, required this.data});

  final ListElement data;

  @override
  State<AppointmentEditPage> createState() => _AppointmentEditPageState();
}

class _AppointmentEditPageState extends State<AppointmentEditPage> {
  // Variables
  String pickupFrom = "";
  bool _pickup = false;
  bool _externalUser = false;
  bool _termsAndCondition = false;

  // bool PersonalDetailExpand = false;

  // validation Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // text Controllers
  TextEditingController _appointmentDate = TextEditingController();
  TextEditingController _noOfDays = TextEditingController();
  TextEditingController _noOfPeople = TextEditingController();
  TextEditingController _pickupPoint = TextEditingController();
  TextEditingController _emergencyContact = TextEditingController();
  TextEditingController _reason = TextEditingController();

  List<TextEditingController> _GroupMembersDataAgeControllers = [];
  List<TextEditingController> _GroupMembersDataRelationControllers = [];
  List<TextEditingController> _GroupMembersDataControllers = [];

  // Define a list to store the expansion state of each item

  List<bool> itemExpandedList = [];
  late List<dynamic> updateMember;

  // List<GroupMember> dataList = [];

  // init State
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Provider.of<AppointmentController>(context, listen: false)
            .countOfPeople = widget.data.numOfPeople ?? 0;
        for (int i = 0;
            i <
                Provider.of<AppointmentController>(context, listen: false)
                    .countOfPeople;
            i++) {
          itemExpandedList.add(true);
        }
      },
    );
    _appointmentDate = TextEditingController(text: widget.data.appointmentDate);
    _noOfDays = TextEditingController(text: widget.data.days);
    _noOfPeople =
        TextEditingController(text: widget.data.numOfPeople.toString());
    _pickupPoint = TextEditingController(text: widget.data.from);
    _emergencyContact =
        TextEditingController(text: widget.data.emergencyNumber);
    _reason = TextEditingController(text: widget.data.appointmentReason);
    _pickup = widget.data.pickup ?? false;
    _externalUser = widget.data.externalUser ?? false;
    // _appointmentForOther = widget.data.externalUser;

    updateMember =
        List<dynamic>.from(widget.data.groupMembers!.map((x) => x.toJson()));

    for (dynamic member in updateMember) {
      GroupMember groupMember = GroupMember.fromJson(member);
      groupMember.id;
      groupMember.appointmentId;
      _GroupMembersDataControllers.add(
          TextEditingController(text: groupMember.name));
      _GroupMembersDataAgeControllers.add(
          TextEditingController(text: groupMember.age));
      _GroupMembersDataRelationControllers.add(
          TextEditingController(text: groupMember.relation));

      debugPrint(groupMember.toString());
    }
  }

  // dispose controllers
  @override
  void dispose() {
    _appointmentDate.dispose();
    _noOfDays.dispose();
    _noOfPeople.dispose();
    _pickupPoint.dispose();
    _emergencyContact.dispose();
    updateMember.clear();
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
  Future<void> _submitForm(List<dynamic> dataList) async {
    if (_formKey.currentState!.validate()) {
      // Date time pick
      String time = DateFormat('hh:mm a').format(DateTime.now());
      var date = DateFormat('dd/MM/yyyy').format(DateTime.now());

      // Appointment Post Data
      ListElement data = ListElement(
        id: widget.data.id,
        uId: widget.data.uId,
        appointmentDate: _appointmentDate.text,
        numOfPeople: Provider.of<AppointmentController>(context, listen: false)
            .countOfPeople,
        pickup: _pickup,
        days: _noOfDays.text,
        from: pickupFrom.isEmpty ? "No Data" : pickupFrom,
        emergencyNumber: _emergencyContact.text,
        appointmentTime: time,
        appointmentReason: _reason.text,
        registerDate: date,
        groupMembers: List<GroupMember>.from(
            dataList.map((x) => GroupMember.fromJson(x))),
        appointmentStatus: "Not Arrived",
        externalUser: _externalUser,
      );
      Provider.of<AppointmentController>(context, listen: false).updateAppointment(context, data);
    }
  }

  // WidgetTree
  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<AppointmentController>(context);
// Iterate through each index
    const int maxCharacters = 100; // Maximum characters allowed
    // const int peopleDigitLimit = 1; // Maximum characters allowed
    const int daysDigitLimit = 2; // Maximum characters allowed
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
            "Edit Appointment",
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
                        prefixIcon: IconButton(
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
                            value: _externalUser,
                            onChanged: (val) {
                              setState(() {
                                _externalUser = !_externalUser;
                              });
                            }),
                        Expanded(child: Text(appointmentForOther))
                      ],
                    ),

                    // spaceBetween,
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
                                  _noOfPeople.text = pro.countOfPeople.toString();
                                  if (pro.countOfPeople < 0) {
                                    pro.countOfPeople--;
                                    pro.countOfPeople = 0;
                                  }
                                  itemExpandedList.removeAt(pro.countOfPeople);
                                },
                                child: Container(
                                    color: inputText,
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
                                        ? inputText
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
                    if (pro.countOfPeople != 0)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                        child: Row(
                          children: [
                            Text("Personal Details"),
                          ],
                        ),
                      ),
                    if (pro.countOfPeople > 0)
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
                            print(_GroupMembersDataControllers[index].text);
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
                                              top: 23.sp, right: 10.sp),
                                          child: Text("#${index + 1}"),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 260.h,
                                            decoration: BoxDecoration(
                                              color: bottomNavLabel,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Column(
                                                children: [
                                                  TextFormField(
                                                    style: TextStyle(
                                                        color: inputText),
                                                    controller: _GroupMembersDataControllers[index],
                                                    decoration: InputDecoration(
                                                      labelText: "Name",
                                                      labelStyle: TextStyle(
                                                          color: placeHolder),
                                                      suffixIcon: InkWell(
                                                        onTap: () {
                                                          _GroupMembersDataControllers[
                                                                  index]
                                                              .clear();
                                                        },
                                                        child: Icon(
                                                          Icons
                                                              .highlight_off_outlined,
                                                          color: iconColor,
                                                        ),
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        borderSide: BorderSide(
                                                            color:
                                                                textFieldOutline),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        borderSide: BorderSide(
                                                          color:
                                                              onSelectTextFieldOutline,
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
                                                              color: inputText),
                                                          controller:
                                                              _GroupMembersDataAgeControllers[
                                                                  index],
                                                          decoration:
                                                              InputDecoration(
                                                            labelText: "Age",
                                                            labelStyle: TextStyle(
                                                                color:
                                                                    placeHolder),
                                                            suffixIcon: InkWell(
                                                              onTap: () {
                                                                _GroupMembersDataAgeControllers[
                                                                        index]
                                                                    .clear();
                                                              },
                                                              child: Icon(
                                                                Icons
                                                                    .highlight_off_outlined,
                                                                color:
                                                                    iconColor,
                                                              ),
                                                            ),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color:
                                                                          textFieldOutline),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              borderSide:
                                                                  BorderSide(
                                                                color:
                                                                    onSelectTextFieldOutline,
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
                                                              color: inputText),
                                                          controller:
                                                              _GroupMembersDataRelationControllers[
                                                                  index],
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                "Relation",
                                                            labelStyle: TextStyle(
                                                                color:
                                                                    placeHolder),
                                                            suffixIcon: InkWell(
                                                              onTap: () {
                                                                _GroupMembersDataRelationControllers[
                                                                        index]
                                                                    .clear();
                                                              },
                                                              child: Icon(
                                                                Icons
                                                                    .highlight_off_outlined,
                                                                color:
                                                                    iconColor,
                                                              ),
                                                            ),
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color:
                                                                          textFieldOutline),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              borderSide:
                                                                  BorderSide(
                                                                color:
                                                                    onSelectTextFieldOutline,
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
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            5.sp,
                                                            16.sp,
                                                            5.sp,
                                                            5.sp),
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
                                                            primary: inputText,
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
                                                                color:
                                                                    bottomNavLabel),
                                                          ),
                                                        ),
                                                        SizedBox(width: 16.w),
                                                        ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            shadowColor:
                                                                Colors.black,
                                                            elevation: 4,
                                                            primary: inputText,
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
                                                                color:
                                                                    bottomNavLabel),
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
                                                        BorderRadius.circular(
                                                            8),
                                                    color: bottomNavLabel),
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
                                                if (widget.data.groupMembers?[index].id != null) {
                                                  deleteMember(context, widget.data.groupMembers?[index].id);
                                                  pro.countOfPeople -= 1;
                                                  itemExpandedList.removeAt(index);
                                                }else{
                                                  // Remove the item at the given index from each TextEditingController list
                                                  _GroupMembersDataControllers.removeAt(index);
                                                  _GroupMembersDataAgeControllers
                                                      .removeAt(index);
                                                  _GroupMembersDataRelationControllers
                                                      .removeAt(index);
                                                  // You also need to decrement the countOfPeople variable if needed
                                                  pro.countOfPeople -= 1;
                                                  itemExpandedList.removeAt(index);
                                                  calculateTotalHeight(itemExpandedList);
                                                  Provider.of<AppointmentController>(
                                                      context,
                                                      listen: false)
                                                      .fetchAppointments();
                                                }
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
                        onPressed: _termsAndCondition != true ? null : ()  {
                                //  This is to add appoint with and without together in edit
                                List<Map<String, dynamic>> memberData = [];
                                for (int i = 0; i <= pro.countOfPeople; i++) {
                                  Map<String, dynamic> member = {};
                                  // Add data from widget.data.groupMembers if available
                                  if (i < widget.data.groupMembers!.length) {
                                    member["id"] = widget.data.groupMembers![i].id;
                                    member["appointmentId"] = widget.data.groupMembers![i].appointmentId;
                                  } else {
                                    member["id"] = null;
                                    member["appointmentId"] = null;
                                  }
                                  // Add data from _GroupMembersDataControllers, _GroupMembersDataAgeControllers, and _GroupMembersDataRelationControllers
                                  String name = _GroupMembersDataControllers[i].text;
                                  String age = _GroupMembersDataAgeControllers[i].text;
                                  String relation = _GroupMembersDataRelationControllers[i].text;

                                  if (name.isNotEmpty &&
                                      age.isNotEmpty &&
                                      relation.isNotEmpty) {
                                    member["name"] = name;
                                    member["age"] = age;
                                    member["relation"] = relation;
                                    memberData.add(member);
                                  }
                                }
                                 _submitForm(memberData);
                                Navigator.pop(context);
                                // pro.countOfPeople = 0;
                              },
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.black,
                          // Customize the shadow color
                          elevation: 4,
                          primary: buttonColor,
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
                                    ? buttonText
                                    : Colors.grey),
                            Text(
                              confirmBooking,
                              style: TextStyle(
                                  color: _termsAndCondition == true
                                      ? buttonText
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
