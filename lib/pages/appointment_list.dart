import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thusmai_appointmrent/services/appointment_api.dart';
import '../constant/constant.dart';
import '../models/appointment_model.dart';
import 'appointment_add.dart';

class AppointmentListPage extends StatefulWidget {
  @override
  _AppointmentListPageState createState() => _AppointmentListPageState();
}

class _AppointmentListPageState extends State<AppointmentListPage> {


  late Future<List<ListElement>> futureAppointments;
  static const String phone = "1234";

  @override
  void initState() {
    super.initState();
    futureAppointments = fetchAppointments(phone);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      body: FutureBuilder<List<ListElement>>(
        future: futureAppointments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(tryAgain));
          } else if (snapshot.data == []) {
            return Center(child: Text(noData));
          } else {
            final appointments = snapshot.data ?? []; // Ensure appointments is not null

            return appointments.isEmpty? Center(child: Text(noData)):ListView.builder(
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
                            padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                            child: Icon(
                              Icons.calendar_month,
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: Text(
                                  'Appointment Id (${appointment.appointmentDate ?? 'N/A'})'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Pickup : ${appointment.from ?? 'N/A'}'),
                                  Text(
                                      'No. of people : ${appointment.numOfPeople ?? 'N/A'}'),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.fromLTRB(0.sp, 20, 0, 10),
                            child: IconButton(
                                onPressed: () async{
                                  // Delete the appointment
                                 await  deleteAppointment(context, appointment.id.toString(),appointment.phone.toString());
                                  setState(() {
                                    futureAppointments = fetchAppointments(phone);
                                  });
                                }, icon: Icon(Icons.delete)),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
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
          color: Colors.black,
          size: 35,
        ),
      ),
    );
  }
}
