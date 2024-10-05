import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constant/constant.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      this.validator,
      required this.hintText,
      this.onChanged,
      this.controller,
      this.errorText,
      this.keyboardType,
      this.prefixIcon,
      this.padding});

  final String hintText;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final bool? padding;
  final String? errorText;

  final TextInputType? keyboardType;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding == true
          ? EdgeInsets.only(bottom: 0.sp)
          : EdgeInsets.only(bottom: 16.sp),
      child: TextFormField(
        controller: controller,
        validator: validator,
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
          prefixIcon: padding == false
              ? Icon(
                  prefixIcon,
                  color: shadeTen,
                )
              : null,
          fillColor: profileTextFieldDillColor,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(color: shadeNine, width: 1),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(color: shadeNine, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(color: shadeNine, width: 1),
          ),
          errorText: errorText,
        ),
      ),
    );
  }
}
