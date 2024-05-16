import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/models/bankdetails.dart';
import '../../../../constant/constant.dart';
import '../../../../controller/profileController.dart';
import '../../../../widgets/custombutton.dart';
import '../../../../widgets/customtextfield.dart';
import '../../../constant/constant.dart';
import 'bank_detail_edit.dart';

class BankDetails extends StatefulWidget {
  const BankDetails({Key? key}) : super(key: key);

  @override
  State<BankDetails> createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var bankDataDetails = Provider.of<ProfileController>(context,listen: false).bankDataDetails;

   var sizeHeight = SizedBox(height: 24);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(

            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: shadeOne,
            )),
        backgroundColor: darkShade,
        title: Text(
          "Bank details",
          style: TextStyle(color: shadeOne),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.fromLTRB(8,24,8,24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex:10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Aadhar number",style: TextStyle(fontSize: 16.sp)),
                        sizeHeight,
                        Text("IFSE code",style: TextStyle(fontSize: 16.sp)),
                        sizeHeight,
                        Text("Branch name",style: TextStyle(fontSize: 16.sp)),
                        sizeHeight,
                        Text("Bank name",style: TextStyle(fontSize: 16.sp)),
                        sizeHeight,
                        Text("Account name",style: TextStyle(fontSize: 16.sp)),
                        sizeHeight,
                        Text("Account number ",style: TextStyle(fontSize: 16.sp)),
                      ],
                    ),
                  ),
                  Flexible(
                    flex:15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(":  ${bankDataDetails?.aadarNo}",style: TextStyle(fontSize: 16.sp),overflow: TextOverflow.ellipsis),
                        sizeHeight,
                        Text(":  ${bankDataDetails?.ifscCode}",style: TextStyle(fontSize: 16.sp),overflow: TextOverflow.ellipsis),
                        sizeHeight,
                        Text(":  ${bankDataDetails?.branchName}",style: TextStyle(fontSize: 16.sp),overflow: TextOverflow.ellipsis),
                        sizeHeight,
                        Text(":  ${bankDataDetails?.bankName}",style: TextStyle(fontSize: 16.sp),overflow: TextOverflow.ellipsis),
                        sizeHeight,
                        Text(":  ${bankDataDetails?.accountName}",style: TextStyle(fontSize: 16.sp),overflow: TextOverflow.ellipsis),
                        sizeHeight,
                        Text(":  ${bankDataDetails?.accountNo}",style: TextStyle(fontSize: 16.sp),overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
              CustomButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BankDetailEdit(),));

                },
                buttonColor: goldShade,
                buttonText: "Edit",
              )
            ],
          ),
        ),
      ),
    );
  }
}

