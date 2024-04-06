import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/pages/appointment/termsandconditions.dart';
import '../../constant/constant.dart';
import '../../controller/appointmentontroller.dart';
import '../../controller/authentication.dart';
import '../../models/appointment_model.dart';
import '../../widgets/additionnalwidget.dart';

class AppointmentEditPage extends StatefulWidget {
  const AppointmentEditPage({super.key, required this.data});

  final ListElement data;

  @override
  State<AppointmentEditPage> createState() => _AppointmentEditPageState();
}

class _AppointmentEditPageState extends State<AppointmentEditPage> {
  String selectedValue ="";
  // init State
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Provider.of<AppointmentController>(context, listen: false)
            .countOfPeople = widget.data.numOfPeople ?? 0;
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
    selectedValue =widget.data.externalUser == true? "Yes" : "No";
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
      itemExpandedList.add(true);
      debugPrint(groupMember.toString());
    }
  }

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

  Future<void> _submitForm(List<dynamic> dataList) async {
    // if (_formKey.currentState!.validate()) {
    // Date time pick
    String time = DateFormat('hh:mm a').format(DateTime.now());
    var date = DateFormat('dd/MM/yyyy').format(DateTime.now());

    // Appointment Post Data
    ListElement data = ListElement(
      id: widget.data.id,
      uId: widget.data.uId,
      userName: widget.data.userName,
      phone: widget.data.phone,
      appointmentDate: _appointmentDate.text,
      numOfPeople: Provider.of<AppointmentController>(context, listen: false)
          .countOfPeople,
      pickup: _pickup,
      days: _noOfDays.text,
      from: pickupFrom.isEmpty ? na : pickupFrom,
      emergencyNumber: _emergencyContact.text,
      appointmentTime: time,
      appointmentReason: _reason.text,
      registerDate: date,
      groupMembers:
          List<GroupMember>.from(dataList.map((x) => GroupMember.fromJson(x))),
      appointmentStatus: "Not Arrived",
      externalUser: _externalUser,
    );

    Provider.of<AppointmentController>(context, listen: false)
        .updateAppointment(context, data);
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

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<AppointmentController>(context);
    const int maxCharacters = 100; // Maximum characters allowed
    const int daysDigitLimit = 2; // Maximum characters allowed
    spaceBetween = SizedBox(
      height: 16.h,
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Provider.of<AppointmentController>(context, listen: false)
                  .fetchAppointments();
              pro.countOfPeople = 0;
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: shadeOne,
            )),
        backgroundColor: darkShade,
        title: Text(
          editAppointment,
          style: TextStyle(color: shadeOne),
        ),
        // centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.sp, 0.sp, 16.sp, 0),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
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
                        borderSide: BorderSide(
                            color: darkShade, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return appointmentDateValidation;
                      }
                      return null;
                    },
                  ),
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
                                    selectedValue = value??"";
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
                                selectedValue = value??"";
                                _externalUser = false;
                              });
                            },
                          ),
                          Text("No")
                        ],
                      ),
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Checkbox(
                  //         side: BorderSide(color: shadeNine, width: 2),
                  //         activeColor: brown,
                  //         value: _externalUser,
                  //         onChanged: (val) {
                  //           setState(() {
                  //             _externalUser = !_externalUser;
                  //           });
                  //         }),
                  //     Expanded(child: Text(appointmentForOther))
                  //   ],
                  // ),

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
                                _noOfPeople.text = pro.countOfPeople.toString();
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
                              borderSide: BorderSide(
                                  color: darkShade, width: 2),
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
                  spaceBetween,
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: pro.countOfPeople,
                itemBuilder: (BuildContext context, int index) {
                  _GroupMembersDataControllers.add(TextEditingController());
                  _GroupMembersDataAgeControllers.add(TextEditingController());
                  _GroupMembersDataRelationControllers.add(TextEditingController());
                  itemExpandedList.add(false);
                  return Column(
                    children: [
                      if (!itemExpandedList[index])
                        Padding(
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
                                child: Container(
                                  height: 260.h,
                                  decoration: BoxDecoration(
                                    color: shadeTwo,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          style: TextStyle(color: darkShade),
                                          controller:
                                              _GroupMembersDataControllers[
                                                  index],
                                          decoration: InputDecoration(
                                            labelText: name,
                                            labelStyle:
                                                TextStyle(color: shadeTen),
                                            suffixIcon: InkWell(
                                              onTap: () {
                                                _GroupMembersDataControllers[
                                                        index]
                                                    .clear();
                                              },
                                              child: Icon(
                                                Icons.highlight_off_outlined,
                                                color: shadeTen,
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: BorderSide(
                                                  color: shadeNine),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
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
                                                    TextInputType.number,
                                                style:
                                                    TextStyle(color: darkShade),
                                                controller:
                                                    _GroupMembersDataAgeControllers[
                                                        index],
                                                decoration: InputDecoration(
                                                  labelText: age,
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
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    borderSide: BorderSide(
                                                        color:
                                                            shadeNine),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    borderSide: BorderSide(
                                                      color:
                                                          darkShade,
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
                                                style:
                                                    TextStyle(color: darkShade),
                                                controller:
                                                    _GroupMembersDataRelationControllers[
                                                        index],
                                                decoration: InputDecoration(
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
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    borderSide: BorderSide(
                                                        color:
                                                            shadeNine),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    borderSide: BorderSide(
                                                      color:
                                                          darkShade,
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
                                                style: ElevatedButton.styleFrom(
                                                  shadowColor: Colors.black,
                                                  elevation: 4,
                                                  primary: darkShade,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
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
                                                  clear,
                                                  style: TextStyle(
                                                      color: shadeTwo),
                                                ),
                                              ),
                                              SizedBox(width: 16.w),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  shadowColor: Colors.black,
                                                  elevation: 4,
                                                  primary: darkShade,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  itemExpandedList[index] =
                                                      true;
                                                  setState(() {});
                                                },
                                                child: Text(
                                                  save,
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
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                                const EdgeInsets.only(left: 8),
                                            child: Text(
                                                "${_GroupMembersDataControllers[index].text},"),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8),
                                            child: Text(
                                                "${_GroupMembersDataAgeControllers[index].text},"),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8),
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
                                    if(updateMember.length > index){
                                      if (updateMember[index].containsKey("id") && updateMember[index]["id"] != null) {
                                        print( updateMember[index]["id"].toString());
                                        pro.deleteMember(context, updateMember[index]["id"]);
                                      }
                                    }
                                    _GroupMembersDataControllers.removeAt(
                                        index);
                                    _GroupMembersDataAgeControllers.removeAt(
                                        index);
                                    _GroupMembersDataRelationControllers
                                        .removeAt(index);
                                    pro.countOfPeople--;
                                    // }
                                  },
                                  icon: Icon(Icons.highlight_off_outlined),
                                )
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
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
                          borderSide: BorderSide(
                              color: darkShade, width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return pickupValidation;
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
                        borderSide: BorderSide(
                            color: darkShade, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return  phoneRequired;
                      }
                      // Define a regular expression for validating phone numbers
                      final RegExp phoneRegex = RegExp(r'^\+?[0-9]{7,13}$');
                      // Allows for optional '+91' country code followed by 7 to 13 digits

                      // Check if the entered value matches the phone number format
                      if (!phoneRegex.hasMatch(value)) {
                        return validNumber;
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
                        borderSide: BorderSide(
                            color: darkShade, width: 2),
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
                                declaration,
                                style:
                                    TextStyle(fontSize: 14, color: darkShade),
                              ),
                              TextSpan(
                                text: termsAndCondition,
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
                                text: declarationBalance,
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
                          : () {
                              // //  This is to add appoint with and without together in edit
                              List<Map<String, dynamic>> memberData = [];
                              if (pro.countOfPeople > 0) {
                                for (int i = 0; i <= pro.countOfPeople; i++) {
                                  Map<String, dynamic> member = {};
                                  // Add data from widget.data.groupMembers if available
                                  if (i < widget.data.groupMembers!.length) {
                                    member["id"] =
                                        widget.data.groupMembers![i].id;
                                    member["appointmentId"] = widget
                                        .data.groupMembers![i].appointmentId;
                                  } else {
                                    member["id"] = null;
                                    member["appointmentId"] = null;
                                  }
                                  // Add data from _GroupMembersDataControllers, _GroupMembersDataAgeControllers, and _GroupMembersDataRelationControllers
                                  String name =
                                      _GroupMembersDataControllers[i].text;
                                  String age =
                                      _GroupMembersDataAgeControllers[i].text;
                                  String relation =
                                      _GroupMembersDataRelationControllers[i]
                                          .text;

                                  if (name.isNotEmpty &&
                                      age.isNotEmpty &&
                                      relation.isNotEmpty) {
                                    member["name"] = name;
                                    member["age"] = age;
                                    member["relation"] = relation;
                                    memberData.add(member);
                                    print(memberData[i].toString());
                                  }
                                }
                              }
                              _submitForm(memberData);
                              // pro.countOfPeople = 0;
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
