import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:thusmai_appointmrent/controller/connectivitycontroller.dart';
import 'package:thusmai_appointmrent/pages/appointment/termsandconditions.dart';
import '../../constant/constant.dart';
import '../../controller/appointmentontroller.dart';
import '../../controller/login_register_otp_api.dart';
import '../../controller/payment_controller.dart';
import '../../widgets/additionnalwidget.dart';
import '../../widgets/deletedialog.dart';
import 'feedback.dart';
import '../refreshpage.dart';
import 'app_new_edit.dart';
import 'appointment_add.dart';
import 'appointment_share.dart';

class AppointmentListPage extends StatefulWidget {
  const AppointmentListPage({Key? key}) : super(key: key);

  @override
  State<AppointmentListPage> createState() => _AppointmentListPageState();
}

class _AppointmentListPageState extends State<AppointmentListPage> {
  @override
  void initState() {
    super.initState();

    Provider.of<AppointmentController>(context, listen: false)
        .fetchAppointments();
    Provider.of<AppointmentController>(context, listen: false)
        .termsAndCondition();
    Provider.of<ConnectivityProvider>(context, listen: false).status;
  }

  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticating = false;

  Future<void> _authenticate(String id) async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Verify to delete',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });

      if (authenticated) {
        _isAuthenticating = true;
        print(_isAuthenticating.toString());
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return DeleteDialog(id);
          },
        );
      } else {}
    } on PlatformException catch (e) {
      _isAuthenticating = true;
      print(_isAuthenticating.toString());
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return DeleteDialog(id);
        },
      );
    }
    if (!mounted) {
      return;
    }
  }

// Function to perform after authentication
// void _performActionAfterAuthentication() {
//   // Implement your logic here
// }

  @override
  Widget build(BuildContext context) {
    var connect = Provider.of<ConnectivityProvider>(context);
    var pro = Provider.of<AppointmentController>(context);
    var flagModel = Provider.of<AppLogin>(context).flagModel;
    var appLogin = Provider.of<AppLogin>(context);
    bool payment = flagModel.meditationFeePaymentStatus ?? false;
    return Scaffold(
      backgroundColor: shadeOne,
      body: connect.status == ConnectivityStatus.Offline
          ? Center(
              child: RefreshPage(
              onTap: () {
                Provider.of<AppointmentController>(context, listen: false)
                    .fetchAppointments();
                Provider.of<AppointmentController>(context, listen: false)
                    .termsAndCondition();
                Provider.of<ConnectivityProvider>(context, listen: false).status;
              },
            ))
          : pro.appointments.isEmpty
              ? Center(
                  child: Text(
                    bookAppointment,
                    style: TextStyle(
                        fontSize: 24.sp, color: Color.fromRGBO(67, 44, 0, .3)),
                  ),
                )
              : ListView.builder(
                  itemCount: pro.appointments.length,
                  itemBuilder: (context, index) {
                    final appointment =
                        pro.appointments.reversed.toList()[index];
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            appointment.appointmentStatus == "Not Arrived"
                                ? slidePageRoute(
                                    context,
                                    AppointmentShare(appointment: appointment),
                                  )
                                : null;
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    'Booking Date (${appointment.registerDate ?? 'N/A'})',
                                    style: TextStyle(
                                        color: darkShade, fontSize: 16.sp),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Check-in date : ${appointment.appointmentDate ?? 'N/A'}',
                                        style: TextStyle(
                                            color: shadeTen, fontSize: 13.sp),
                                      ),
                                      Text(
                                        'Check-out date : ${appointment.checkOut ?? 'N/A'}',
                                        style: TextStyle(
                                            color: shadeTen, fontSize: 13.sp),
                                      ),
                                      Text(
                                        'No. of people : ${appointment.numOfPeople}',
                                        style: TextStyle(
                                            color: shadeTen, fontSize: 13.sp),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              appointment.appointmentStatus == "Not Arrived"
                                  ? Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              0.sp, 10, 0, 0),
                                          child: IconButton(
                                              onPressed: () {
                                                slidePageRoute(
                                                    context,
                                                    AppointmentEditPage(
                                                        data: appointment));
                                              },
                                              icon: Icon(Icons.edit,
                                                  color: shadeTen)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              0.sp, 10, 0, 0),
                                          child: IconButton(
                                            onPressed: () async {
                                              await _authenticate(
                                                  appointment.id.toString());
                                            },
                                            icon:
                                                Icon(Icons.delete, color: red),
                                          ),
                                        ),
                                      ],
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        slidePageRoute(context,
                                            FeedBack(id: appointment.id));
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
                                                color: darkShade,
                                                fontSize: 12.sp),
                                          )),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              border:
                                                  Border.all(color: goldShade)),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        Divider(
                          color: shadeFour,
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
          Stack(
            alignment: Alignment.center,
            children: [
              FloatingActionButton(
                heroTag: 1,
                backgroundColor: shadeEight,
                onPressed: () {
                  slidePageRoute(context, TermsAndConditions());
                },
                child: Icon(
                  Icons.info_outline,
                  size: 30,
                  color: darkShade,
                ),
                mini: false,
              ),
              GestureDetector(
                onTap: () {
                  slidePageRoute(context, TermsAndConditions());
                },
                child: Shimmer.fromColors(
                  baseColor: Colors.transparent,
                  direction: ShimmerDirection.ltr,
                  loop: 10,
                  highlightColor: Colors.white.withOpacity(0.3),
                  child: Container(
                    width: 60.w, // default size of FloatingActionButton
                    height: 60.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Shimmer.fromColors(
          //   baseColor: Colors.grey,
          //   highlightColor: Colors.white,
          //   child: FloatingActionButton(
          //     heroTag: 1,
          //     backgroundColor: shadeEight,
          //     onPressed: () {
          //       slidePageRoute(context, TermsAndConditions());
          //     },
          //     child: Icon(
          //       Icons.info_outline,
          //       size: 30,
          //       color:
          //           darkShade, // This color will be overridden by the shimmer effect
          //     ),
          //     mini: false, // Set mini to true to reduce the size
          //   ),
          // ),
          SizedBox(
            height: 16.h,
          ),
          Tooltip(
            message: payment == false ? 'Enable payments to proceed' : 'Add Appointment',
            child:  FloatingActionButton(
              heroTag: 2,
              backgroundColor: payment == false ? Colors.grey : goldShade,
              onPressed: payment == false
                  ? () {
                      appLogin.currentIndex = 3;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(enable),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  : () {
                      slidePageRoute(context, AppointmentAddPage());
                    },
              child: Icon(
                Icons.add,
                color: payment == false ? Colors.white : shadeTen,
                size: 35.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
