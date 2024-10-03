import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';

class DatePickerField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;

  const DatePickerField({
    Key? key,
    required this.hintText,
    required this.controller,
  }) : super(key: key);

  @override
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1800),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        widget.controller.text = DateFormat('dd-MM-yyyy').format(pickedDate); // Format the date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      readOnly: true, // Prevent manual input
      onTap: () => _selectDate(context), // Show date picker on tap
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(fontWeight: FontWeight.normal),
        suffixIcon: Icon(Icons.calendar_today), // Calendar icon
        filled: true,
        fillColor: profileTextFieldDillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.sp),
          borderSide: BorderSide(color: shadeNine)
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.sp),
            borderSide: BorderSide(color: shadeNine)
        ),
      ),
    );
  }
}
