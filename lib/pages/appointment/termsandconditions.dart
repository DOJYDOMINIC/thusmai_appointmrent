import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';

import '../../controller/appointmentontroller.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {

  @override
  void initState() {
    super.initState();
    // Provider.of<AppointmentController>(context, listen: false).termsAndCondition();
  }


  @override
  Widget build(BuildContext context) {
   var pro =  Provider.of<AppointmentController>(context,);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkShade,
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
              pro.tAndC.isNotEmpty ?  Text("${pro.tAndC}"):Center(child: CircularProgressIndicator()),
              SizedBox(height: 20.sp,),
            ],
          ),
        ),
      ),
    );
  }
}
