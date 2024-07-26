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
              pro.tAndC.isNotEmpty ?  Text(pro.tAndC,textAlign: TextAlign.justify,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14.sp)):Center(child: CircularProgressIndicator()),
              SizedBox(height: 20.sp,),
            ],
          ),
        ),
      ),
    );
  }
}


// var dd = "*Ashram Visit Guidelines and Regulations\nWelcome to the Ashram! To ensure a harmonious and enriching experience during your stay with Guruji, please take note of the following essential guidelines:\n *Entry Regulations \nPermission Required: No entry to Guruji's residence without prior permission.\nContact Information: For any queries, you can call +91 90082 90027. If unavailable, please consult Lakshman.\nHealth Precautions\nHealth Advisory: Visitors with fever, cough, cold, or any other infectious disease are advised to postpone their visit to the Ashram until fully recovered.\nProhibited Items\nIntoxicants and Food Restrictions: Intoxicants and foreign foods are strictly prohibited, except for fruits and vegetables.\nDaily Schedule\nMorning Routine:\n4:30 AM: Tea is available in the kitchen.\n5:00 AM: Sit under the open sky to listen to the classes.\n6:00 AM - 6:30 AM: Exercise time.\nBefore 7:00 AM: Meditation session.\nSpecial care should be taken to leave the mobile room at the top for meditation and exercise.\nAfter 8:00 AM: Breakfast is served.\nDaytime Rules\nSeva and Rest:\nDaytime sleeping is not permitted; Ashram seva (service) is encouraged during later hours.\n1:00 PM: Lunch is served.\n4:00 PM: Tea time.\nIt is forbidden to leave the ashram and eat after 6:00 PM.\nMobile Phone Use\nUsage Guidelines: Unnecessary use of mobile phones and staying in the room all the time are against ashram rules.\nMeeting Guruji: Residents wishing to see Guruji should inform Lakshman and leave their mobiles in the room.\nConduct and Attitude\nRespect and Service: Visitors should come with the conviction to gain knowledge from Guruji. Treat every task as a service to the Guru and strive to use every moment beneficially for yourself and others.\nCleanliness and Maintenance\nRoom Care: Report any damaged equipment upon entering the room. Keep rooms, premises, toilets, and bathrooms clean to diminish ego and respect the next user.\nUtilities: Use water and electricity sparingly. Ensure lights, fans, heaters, etc., are switched off when not needed. Close windows and doors when leaving the room.\nMonkey Alert: Be cautious with items like mobiles, purses, and gold as monkeys may be attracted to them.\nPersonal and Shared Responsibilities\nBlankets and Pillowcases: It is recommended to carry your own blankets and pillowcases.\nDakshina: Unwashed cloth and mat materials left behind will be considered as Dakshina (offering) to the Guru.\nRestrictions: Minors, women, sick, or incapacitated individuals are not allowed to stay alone.\nGifts and Donations\nGifts: Avoid bringing specially prepared food items or other gifts for Guruji and his family.\nDonations: Those interested in donating to the Ashram can hand over their contributions to Lakshman.\n";