import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constant/constant.dart';
import 'delete_confirm.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  bool ratingBad = false;
  bool ratingAverage = false;
  bool ratingExcellent = false;
  String status = '';
  String _password = '';
  bool _isPasswordVisible = true;

  List dataText = [
    {"text": "Personal information and account settings."},
    {"text": "Purchased items, subscriptions, and licenses."},
    {"text": "Any stored files or data."},
    {"text": "Social connections and interactions within the platform."},
    {"text": "Historical activity logs and records."}
  ];

  TextEditingController remark = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: shadeOne,
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
          deleteAccount,
          style: TextStyle(color: shadeOne),
        ),
        // centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    deleteQus,
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24,right: 24,top: 8,bottom: 8),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: red, width: 1.5)),
                        child: Padding(
                          padding: EdgeInsets.all(24.sp),
                          child: Row(
                            children: [
                              Icon(Icons.warning_amber_rounded,
                                  color: red, size: 64.sp),
                              SizedBox(
                                width: 8.w,
                              ),
                              Expanded(
                                child: Text(
                                  "This action is permanent and cannot be undone.",
                                  style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Text(
                      deleteDeclaration),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 210.h,
                      child: Scrollbar(
                        interactive: true,
                        thickness: 2,
                        child: ListView.builder(
                          itemCount: dataText.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8, right: 10),
                                  child: Icon(Icons.circle, size: 6),
                                ),
                                Expanded(child: Text(dataText[index]["text"])),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 56.h,
                  ),

                  SizedBox(
                    height: 56.h,
                    width: 304.w,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DeleteConfermation(),));
                      },
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.black,
                        backgroundColor: red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Delete",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24.h,
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
