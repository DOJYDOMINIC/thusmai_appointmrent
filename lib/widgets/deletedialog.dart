import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Import Cupertino library for iOS specific widgets
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../constant/constant.dart';
import '../controller/appointmentontroller.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog(this.id, {Key? key}) : super(key: key);

  final id;

  @override
  Widget build(BuildContext context) {
    var size = SizedBox(height: 24.h);
    // Check platform and return corresponding dialog
    return Theme(
      data: ThemeData(
        cupertinoOverrideTheme: CupertinoThemeData(
          brightness: Brightness.dark, // You can customize the brightness for iOS here
        ),
      ),
      child: Builder(
        builder: (context) {
          if (Theme.of(context).platform == TargetPlatform.iOS) {
            return CupertinoAlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  size,
                  Container(
                    height: 105.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(alertDeleted),
                      ),
                    ),
                  ),
                  size,
                  Text(
                    areYouSure,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 20.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    bookingCancelMessage,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  size,
                  CupertinoButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await Provider.of<AppointmentController>(context, listen: false).deleteAppointment(context,id);
                    },
                    color: CupertinoColors.systemRed,
                    child: Text(confirm),
                  ),
                  size,
                  CupertinoButton(
                    child: Text(cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          } else {
            return AlertDialog(
              backgroundColor: shadeOne,
              elevation: 4,
              shadowColor: Color.fromRGBO(186, 26, 26, 1),
              content: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    size,
                    Container(
                      height: 105.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(alertDeleted),
                        ),
                      ),
                    ),
                    size,
                    Text(
                      areYouSure,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 20.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      bookingCancelMessage,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    size,
                    SizedBox(
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await Provider.of<AppointmentController>(context, listen: false).deleteAppointment(context,id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(186, 26, 26, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              confirm,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    size,
                    TextButton(
                      child: const Text(
                        cancel,
                        style: TextStyle(
                          color: Color.fromRGBO(186, 26, 26, 1),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
