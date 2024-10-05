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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _aadharNumber = TextEditingController();
  TextEditingController _ifscCode = TextEditingController();
  TextEditingController _branchName = TextEditingController();
  TextEditingController _bankName = TextEditingController();
  TextEditingController _accountName = TextEditingController();
  TextEditingController _accountNumber = TextEditingController();

  @override
  void initState() {
    super.initState();
    var bankDataDetails =
        Provider.of<ProfileController>(context, listen: false).bankDataDetails;
    _aadharNumber = TextEditingController(text: bankDataDetails?.aadarNo);
    _ifscCode = TextEditingController(text: bankDataDetails?.ifscCode);
    _branchName = TextEditingController(text: bankDataDetails?.branchName);
    _bankName = TextEditingController(text: bankDataDetails?.bankName);
    _accountName = TextEditingController(text: bankDataDetails?.accountName);
    _accountNumber = TextEditingController(text: bankDataDetails?.accountNo);
  }

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
          "Edit Bank Details ",
          style: TextStyle(color: shadeOne),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    hintText: 'Aadhar number ',
                    controller: _aadharNumber,
                    keyboardType: TextInputType.number,
                    validator: (val) => validateAadharcard(val!),
                  ),
                  CustomTextField(
                    hintText: 'IFSC Code',
                    controller: _ifscCode,
                    validator: (val) => validateIFSC(val!),
                  ),
                  CustomTextField(
                    hintText: 'Branch Name',
                    controller: _branchName,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please enter branch name';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    hintText: 'Bank Name',
                    controller: _bankName,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please enter bank name';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    hintText: 'Account name',
                    controller: _accountName,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please enter account name';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    hintText: 'Account Number',
                    controller: _accountNumber,
                    keyboardType: TextInputType.number,
                    validator: (val) => validateAccountNumber(val!),
                  ),
                  SizedBox(height: 24),
                  CustomButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        BankDetail bankDetails = BankDetail(
                          aadarNo: _aadharNumber.text,
                          bankName: _bankName.text.toUpperCase(),
                          branchName: _branchName.text.toUpperCase(),
                          accountName: _accountName.text.toUpperCase(),
                          accountNo: _accountNumber.text,
                          ifscCode: _ifscCode.text,
                        );

                        Provider.of<ProfileController>(context, listen: false)
                            .bankDetailsData(context, bankDetails);
                      }
                    },
                    buttonColor: goldShade,
                    buttonText: "Save",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String? validateAadharcard(String value) {
  String pattern = r'^[2-9]{1}[0-9]{11}$';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    return 'Please enter Aadhar card number';
  } else if (!regExp.hasMatch(value)) {
    return 'Please enter a valid Aadhar card number';
  } else if (!VerhoeffAlgorithm.validateVerhoeff(value)) {
    return 'Please enter a valid Aadhar card number';
  }
  return null;
}

String? validateIFSC(String value) {
  String pattern = '^[A-Z]{4}0[A-Z0-9]{6}\$';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    return 'Please Enter IFSC';
  } else if (!regExp.hasMatch(value)) {
    return 'Please Enter valid IFSC';
  }
  return null;
}

String? validateAccountNumber(String value) {
  String pattern = '[0-9]{9,18}';
  RegExp regExp = RegExp(pattern);
  if (value.isEmpty) {
    return 'Please Enter Account Number';
  } else if (!regExp.hasMatch(value)) {
    return 'Please Enter Valid Account Number';
  }
  return null;
}

class VerhoeffAlgorithm {
  static final List<List<int>> d = [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 2, 3, 4, 0, 6, 7, 8, 9, 5],
    [2, 3, 4, 0, 1, 7, 8, 9, 5, 6],
    [3, 4, 0, 1, 2, 8, 9, 5, 6, 7],
    [4, 0, 1, 2, 3, 9, 5, 6, 7, 8],
    [5, 9, 8, 7, 6, 0, 4, 3, 2, 1],
    [6, 5, 9, 8, 7, 1, 0, 4, 3, 2],
    [7, 6, 5, 9, 8, 2, 1, 0, 4, 3],
    [8, 7, 6, 5, 9, 3, 2, 1, 0, 4],
    [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
  ];

  static final List<List<int>> p = [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 5, 7, 6, 2, 8, 3, 0, 9, 4],
    [5, 8, 0, 3, 7, 9, 6, 1, 4, 2],
    [8, 9, 1, 6, 0, 4, 3, 5, 2, 7],
    [9, 4, 5, 3, 1, 2, 6, 8, 7, 0],
    [4, 2, 8, 6, 5, 7, 3, 9, 0, 1],
    [2, 7, 9, 3, 8, 0, 6, 4, 1, 5],
    [7, 0, 4, 6, 9, 1, 3, 2, 5, 8]
  ];

  static final List<int> inv = [0, 4, 3, 2, 1, 5, 6, 7, 8, 9];

  static bool validateVerhoeff(String num) {
    int c = 0;
    List<int> myArray = stringToReversedIntArray(num);
    for (int i = 0; i < myArray.length; i++) {
      c = d[c][p[i % 8][myArray[i]]];
    }
    return (c == 0);
  }

  static List<int> stringToReversedIntArray(String num) {
    List<int> myArray =
        List<int>.generate(num.length, (i) => int.parse(num[i]));
    return myArray.reversed.toList();
  }
}
