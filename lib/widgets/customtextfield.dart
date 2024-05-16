import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/constant.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key,this.validator, required this.hintText, this.onChanged, this.controller, this.keyboardType, this.prefixIcon});

  final String hintText;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
final TextInputType? keyboardType;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(bottom: 16.sp),
      child: SizedBox(
        height: 56,
        child: TextFormField(
          controller: controller,
          validator:validator,
          onChanged: onChanged,
          keyboardType: keyboardType,
          style: TextStyle(
            color: shadeTen,
            fontSize: 16.sp,
          ),
          cursorColor: shadeTen,
          decoration: InputDecoration(
            labelText: hintText,
            labelStyle: TextStyle(
              color: shadeTen,
              fontWeight: FontWeight.normal,
            ),
            prefixIcon: Icon(
             prefixIcon,
              color: shadeTen,
            ),
            fillColor: profileTextFieldDillColor,
            filled: true,
            enabledBorder:OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(color: shadeNine,width: 1),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(color: shadeNine,width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(color: shadeNine,width: 1),
            ),
          ),
        ),
      ),
    );
  }
}
