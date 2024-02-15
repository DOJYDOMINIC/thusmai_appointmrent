import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thusmai_appointmrent/services/appointment_api.dart';
import '../constant/appointment_constant.dart';
import '../models/appointment_model.dart';
import 'appointment_add.dart';

class AppointmentListPage extends StatefulWidget {
  const AppointmentListPage({
    Key? key,
    this.phone,
  }) : super(key: key);
  final phone;

  @override
  _AppointmentListPageState createState() => _AppointmentListPageState();
}

class _AppointmentListPageState extends State<AppointmentListPage> {
  @override
  void initState() {
    super.initState();
    fetchDta();
  }

  Future<void> fetchDta() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    phone = prefs.getString("phone")!;
    fetchAppointments(phone);
  }

  String phone = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      body: FutureBuilder<List<ListElement>>(
        future: fetchAppointments(phone),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 5,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(255, 185, 77, 1)),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(tryAgain));
          } else if (snapshot.data == []) {
            return Center(child: Text(noData));
          } else {
            final appointments =
                snapshot.data ?? []; // Ensure appointments is not null

            return appointments.isEmpty
                ? Center(
                    child: Text(
                    "No Appointments Booked !",
                    style: GoogleFonts.schoolbell(
                        fontSize: 24.sp, color: Color.fromRGBO(67, 44, 0, .3)),
                  ))
                : ListView.builder(
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      final appointment = appointments[index];
                      // print("Print : ${appointment.appointmentStatus.toString()}");
                      return Column(
                        children: [
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 5, 10),
                                  child: Icon(
                                    Icons.calendar_month,color: iconColor,
                                  ),
                                ),
                                Expanded(
                                  child: ListTile(
                                    title: Text(
                                        'Id :${appointment.id} (${appointment.appointmentDate ?? 'N/A'})',style: TextStyle(color: heading),),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Pickup : ${appointment.from ?? "no data"}',style: TextStyle(color: subtext),),
                                        Text(
                                            'No. of people : ${appointment.numOfPeople ?? 'N/A'}',style: TextStyle(color: subtext),),
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
                                              shadowColor: Color.fromRGBO(
                                                  186, 26, 26, 1),
                                              content: SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    size,
                                                    Image.asset(
                                                      "assets/images/Alert Delete.png",
                                                      height: 100,
                                                      // Adjust height as needed
                                                      width: 100,
                                                      // Make image take full width
                                                      fit: BoxFit
                                                          .cover, // Fill the space
                                                    ),
                                                    size,
                                                    Text(
                                                      "Are you sure to delete ? ",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 20,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    SizedBox(
                                                      height: 16,
                                                    ),
                                                    Text(
                                                      "Booking cancellation occurs when an \nappointment is deleted. ",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 12,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    size,
                                                    SizedBox(
                                                      height: 56,
                                                      child: ElevatedButton(
                                                        onPressed: () async {
                                                          deleteAppointment(context, appointment.id.toString(), appointment.phone.toString());
                                                          Navigator.of(context)
                                                              .pop();
                                                          await fetchAppointments(phone ?? "");
                                                          setState(() {});
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary:
                                                              Color.fromRGBO(
                                                                  186,
                                                                  26,
                                                                  26,
                                                                  1),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16), // Adjust the radius as needed
                                                          ), // Example color, change it according to your preference
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "Confirm",
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
                                                        'Cancel',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    186,
                                                                    26,
                                                                    26,
                                                                    1)),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        // Perform OK action
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      icon: Icon(Icons.delete,color: iconColor,)),
                                ),
                              ],
                            ),
                          ),
                          if (index == appointments.length - 1) // Add SizedBox only for the last item
                            SizedBox(height: 70.sp),
                          if (index != appointments.length - 1) // Conditionally show divider for items other than the last one
                            Divider(
                              color: dividerLine,
                              thickness: 1,
                            ),
                        ],
                      );
                    },
                  );
          }
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
                    begin: Offset(1.0, 0.0), // specify the starting position
                    end: Offset.zero, // specify the ending position
                  ).animate(animation),
                  child: child,
                );
              },
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secAnimation) {
                // This is where you build the widget to navigate to
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
