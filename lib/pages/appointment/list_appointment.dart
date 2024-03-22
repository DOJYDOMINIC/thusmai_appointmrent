import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/controller/connectivitycontroller.dart';
import 'package:thusmai_appointmrent/pages/appointment/termsandconditions.dart';
import '../../constant/constant.dart';
import '../../controller/appointmentontroller.dart';
import '../../widgets/feedback.dart';
import '../refreshpage.dart';
import 'appointment_add.dart';
import 'appointment_edit.dart';

class AppointmentListPage extends StatefulWidget {
  const AppointmentListPage({Key? key}) : super(key: key);

  @override
  State<AppointmentListPage> createState() => _AppointmentListPageState();
}

class _AppointmentListPageState extends State<AppointmentListPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).status;
    Provider.of<AppointmentController>(context, listen: false).fetchAppointments();
  }

  @override
  Widget build(BuildContext context) {
    var connect = Provider.of<ConnectivityProvider>(context);
    var pro = Provider.of<AppointmentController>(context);
    return Scaffold(
      backgroundColor: pageBackground,
      body: connect.status == ConnectivityStatus.Offline ? Center(child: RefreshPage(onTap: (){},)): pro.appointments.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: pro.appointments.length,
                  itemBuilder: (context, index) {
                    final appointment = pro.appointments.toList()[index];
                    return Column(
                      children: [
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    'Booking Date (${appointment.registerDate ?? 'N/A'})',
                                    style: TextStyle(
                                        color: heading, fontSize: 16.sp),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Check-in date : ${appointment.appointmentDate ?? 'N/A'}',
                                        style: TextStyle(
                                            color: subtext, fontSize: 13.sp),
                                      ),
                                      Text(
                                        'Check-out date : ${appointment.checkOut ?? 'N/A'}',
                                        style: TextStyle(
                                            color: subtext, fontSize: 13.sp),
                                      ),
                                      Text(
                                        'No. of people : ${appointment.numOfPeople}',
                                        style: TextStyle(
                                            color: subtext, fontSize: 13.sp),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // if (appointment.checkOut == null)
                              appointment.appointmentStatus == "Not Arrived"
                              // appointment.appointmentStatus == "p"
                                  ? Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              0.sp, 10, 0, 0),
                                          child: IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.share,
                                                  color: iconColor)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              0.sp, 10, 0, 0),
                                          child: IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                    transitionDuration: Duration(milliseconds: 500),
                                                    transitionsBuilder: (BuildContext context, Animation<double> animation,
                                                        Animation<double> secAnimation, Widget child) {
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
                                                      return AppointmentEditPage(data:pro.appointments[index]);
                                                    },
                                                  ),
                                                );
                                              },
                                              icon: Icon(Icons.edit,
                                                  color: iconColor)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              0.sp, 10, 0, 0),
                                          child: IconButton(
                                            onPressed: () async {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  var size = SizedBox(
                                                    height: 24.h,
                                                  );
                                                  return AlertDialog(
                                                    backgroundColor:
                                                        pageBackground,
                                                    elevation: 4,
                                                    shadowColor: Color.fromRGBO(
                                                        186, 26, 26, 1),
                                                    content: SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          size,
                                                          Container(
                                                            height: 105.h,
                                                            width: 100.w,
                                                            decoration:
                                                                BoxDecoration(
                                                              image: DecorationImage(
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  image: AssetImage(
                                                                      alertDeleted)),
                                                            ),
                                                          ),
                                                          size,
                                                          Text(
                                                            areYouSure,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 20.sp,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          SizedBox(
                                                            height: 16,
                                                          ),
                                                          Text(
                                                            bookingCancelMessage,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 12.sp,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          size,
                                                          SizedBox(
                                                            height: 56.h,
                                                            child:
                                                                ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                await Provider.of<
                                                                            AppointmentController>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .deleteAppointment(
                                                                        context,
                                                                        appointment
                                                                            .id
                                                                            .toString());
                                                                await pro
                                                                    .fetchAppointments();
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                primary: Color
                                                                    .fromRGBO(
                                                                        186,
                                                                        26,
                                                                        26,
                                                                        1),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16),
                                                                ),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    confirm,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
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
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          186,
                                                                          26,
                                                                          26,
                                                                          1)),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            icon:
                                                Icon(Icons.delete, color: red),
                                          ),
                                        ),
                                      ],
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        feedBackDialog(context);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: 16.sp, top: 8.sp),
                                        child: Container(
                                          height: 24,
                                          width: 87,
                                          child: Center(
                                              child: Text(
                                            "Feedback",
                                            style: TextStyle(
                                                color: inputText,
                                                fontSize: 12.sp),
                                          )),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              border: Border.all(
                                                  color: buttonColor)),
                                        ),
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
                          SizedBox(height: 70.h),
                      ],
                    );
                  },
                ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 1,
            backgroundColor: floatingAction,
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 500),
                  transitionsBuilder: (BuildContext context, Animation<double> animation,
                      Animation<double> secAnimation, Widget child) {
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
                    return TermsAndConditions();
                  },
                ),
              );
            },
            child: Icon(
              Icons.info_outline,
              color: inputText,
            ),
            mini: true, // Set mini to true to reduce the size
          ),
          SizedBox(
            height: 16.h,
          ),
          FloatingActionButton(
            heroTag: 2,
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
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    );
                  },
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secAnimation) {
                    return const AppointmentAddPage();
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
        ],
      ),
    );
  }
}
