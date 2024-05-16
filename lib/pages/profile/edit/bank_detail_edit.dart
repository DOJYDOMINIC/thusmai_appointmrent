import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/models/bankdetails.dart';
import '../../../constant/constant.dart';
import '../../../controller/profileController.dart';
import '../../../widgets/custombutton.dart';
import '../../../widgets/customtextfield.dart';

class BankDetailEdit extends StatefulWidget {
  const BankDetailEdit({Key? key}) : super(key: key);

  @override
  State<BankDetailEdit> createState() => _BankDetailEditState();
}

class _BankDetailEditState extends State<BankDetailEdit> {

  @override
  void initState() {
    super.initState();
  var bankDataDetails = Provider.of<ProfileController>(context,listen: false).bankDataDetails;
     _aadharNumber = TextEditingController(text: bankDataDetails?.aadarNo);
     _ifscCode = TextEditingController(text: bankDataDetails?.ifscCode);
     _branchName = TextEditingController(text: bankDataDetails?.branchName);
     _bankName = TextEditingController(text: bankDataDetails?.bankName);
     _accountName = TextEditingController(text: bankDataDetails?.accountName);
     _accountNumber = TextEditingController(text: bankDataDetails?.accountNo);
  }

  TextEditingController _aadharNumber = TextEditingController();
  TextEditingController _ifscCode = TextEditingController();
  TextEditingController _branchName = TextEditingController();
  TextEditingController _bankName = TextEditingController();
  TextEditingController _accountName = TextEditingController();
  TextEditingController _accountNumber = TextEditingController();

  String _userName = "";

  @override
  Widget build(BuildContext context) {
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
          "Edit personal info",
          style: TextStyle(color: shadeOne),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.all(16),
            child: Column(
              children: [
                CustomTextField(hintText: 'Aadhar number ',controller: _aadharNumber,),
                CustomTextField(hintText: 'IFSE Code',controller: _ifscCode,),
                CustomTextField(hintText: 'Branch Name',controller: _branchName,),
                CustomTextField(hintText: 'Bank Name',controller: _bankName,),
                CustomTextField(hintText: 'Account name',controller: _accountName,),
                CustomTextField(hintText: 'Account Number',controller: _accountNumber,),
                SizedBox(height: 24,),
                CustomButton(onPressed: (){
                  BankDetail bankDetails = BankDetail(
                    aadarNo: _aadharNumber.text,
                    bankName: _bankName.text,
                    branchName: _branchName.text,
                    accountName: _accountName.text,
                    accountNo: _accountNumber.text,
                    ifscCode: _ifscCode.text
                  );

                  Provider.of<ProfileController>(context,listen: false).bankDetailsData(context, bankDetails);
                }, buttonColor: goldShade,buttonText: "Save",)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

