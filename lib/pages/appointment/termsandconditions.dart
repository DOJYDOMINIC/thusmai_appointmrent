import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbar,
        title: Text(
          "Terms and Conditions",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.only( left: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.sp,),
              Text("${tAndC["content"]}"),
              SizedBox(height: 20.sp,),
            ],
          ),
        ),
      ),
    );
  }
}
