import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/constant.dart';

class DropdownTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final List<String> items; // List of dropdown items
  final String dropdownHint;
  final Function(String?) onItemSelected; // Callback to return selected item

  const DropdownTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.items,
    this.dropdownHint = 'Select',
    required this.onItemSelected,
  }) : super(key: key);

  @override
  _DropdownTextFieldState createState() => _DropdownTextFieldState();
}

class _DropdownTextFieldState extends State<DropdownTextField> {
  String? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: _selectedItem,
          hint: Text(widget.dropdownHint,
          style:TextStyle(fontWeight: FontWeight.normal),

          ),
          icon: Icon(Icons.arrow_drop_down), // Dropdown icon
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(overflow: TextOverflow.ellipsis),
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
          items: widget.items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value,style:TextStyle(fontWeight: FontWeight.normal),),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedItem = newValue; // Update the selected item
              widget.controller.text = newValue ?? ''; // Update the text field with selected value
              widget.onItemSelected(newValue); // Trigger the callback to pass the selected item
            });
          },
        ),
      ],
    );
  }
}
