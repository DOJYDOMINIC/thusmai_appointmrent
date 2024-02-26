import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../constant/constant.dart';
import '../../controller/providerdata.dart';
import '../../services/appointment_api.dart';
import 'appointment_add.dart';

class AppointmentListPage extends StatefulWidget {
  const AppointmentListPage({Key? key}) : super(key: key);

  @override
  State<AppointmentListPage> createState() => _AppointmentListPageState();
}

class _AppointmentListPageState extends State<AppointmentListPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProviderController>(context, listen: false).fetchAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      body: Consumer<ProviderController>(
        builder: (context, pro, _) {
          if (pro.appointments.isEmpty) {
            return Center(
              child: Text(
                noAppointmentsBooked,
                style: GoogleFonts.schoolbell(
                    fontSize: 24.sp, color: Color.fromRGBO(67, 44, 0, .3)),
              ),
            );
          }
          return pro.appointments.isEmpty ?CircularProgressIndicator() : ListView.builder(
            itemCount: pro.appointments.length,
            itemBuilder: (context, index) {
              final appointment = pro.appointments.reversed.toList()[index];
              return Column(
                children: [
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                          child: Icon(
                            Icons.calendar_month,
                            color: iconColor,
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              'Id :${appointment.id} (${appointment.appointmentDate ?? 'N/A'})',
                              style: TextStyle(color: heading),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pickup : ${appointment.from ?? "no data"}',
                                  style: TextStyle(color: subtext),
                                ),
                                Text(
                                  'No. of people : ${appointment.numOfPeople ?? 'N/A'}',
                                  style: TextStyle(color: subtext),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.sp, 20, 0, 10),
                          child: IconButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  var size = SizedBox(
                                    height: 24,
                                  );
                                  return AlertDialog(
                                    backgroundColor: pageBackground,
                                    elevation: 4,
                                    shadowColor: Color.fromRGBO(186, 26, 26, 1),
                                    content: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          size,
                                          Image.asset(
                                            "assets/images/Alert Delete.png",
                                            height: 100.h,
                                            width: 100.w,
                                            fit: BoxFit.cover,
                                          ),
                                          size,
                                          Text(
                                            "Are you sure to delete ? ",
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
                                            "Booking cancellation occurs when an \nappointment is deleted. ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 12.sp,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          size,
                                          SizedBox(
                                            height: 56,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                                await deleteAppointment(context,
                                                    appointment.id.toString());
                                                await pro.fetchAppointments();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                primary: Color.fromRGBO(
                                                    186, 26, 26, 1),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Confirm",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          size,
                                          TextButton(
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      186, 26, 26, 1)),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.delete, color: iconColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: dividerLine,
                    thickness: 1,
                  ),
                  if (index ==
                      pro.appointments.length -
                          1) // Add SizedBox only for the last item
                    SizedBox(height: 70.sp),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: buttonColor,
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 500),
              transitionsBuilder: (BuildContext context,
                  Animation<double> animation,
                  Animation<double> secAnimation,
                  Widget child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secAnimation) {
                return AppointmentPage();
              },
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: iconColor,
          size: 35.sp,
        ),
      ),
    );
  }
}
