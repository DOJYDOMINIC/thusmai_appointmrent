// import 'package:connectivity/connectivity.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:thusmai_appointmrent/services/appointment_api.dart';
// import '../../constant/constant.dart';
// import '../../controller/providerdata.dart';
// import '../../models/appointment_model.dart';
// import 'appointment_add.dart';
//
// class AppointmentListPage extends StatefulWidget {
//   const AppointmentListPage({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   _AppointmentListPageState createState() => _AppointmentListPageState();
// }
//
// class _AppointmentListPageState extends State<AppointmentListPage> {
//   @override
//   void initState() {
//     super.initState();
//     checkConnectivity();
//   }
//
//   bool _isConnected = true;
//
//   Future<void> checkConnectivity() async {
//     ConnectivityResult result = await Connectivity().checkConnectivity();
//     setState(() {
//       _isConnected = result != ConnectivityResult.none;
//     });
//
//     Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
//       setState(() {
//         _isConnected = result != ConnectivityResult.none;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var pro = Provider.of<ProviderController>(context);
//     return Scaffold(
//       backgroundColor: pageBackground,
//       body: _isConnected
//           ? FutureBuilder<List<ListElement>>(
//               future: fetchAppointments(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(
//                     child: CircularProgressIndicator(
//                       strokeWidth: 5,
//                       valueColor: AlwaysStoppedAnimation<Color>(
//                           Color.fromRGBO(255, 185, 77, 1)),
//                     ),
//                   );
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text(tryAgain));
//                 } else if (snapshot.data == []) {
//                   return Center(child: Text(noData));
//                 } else {
//                   final appointments = snapshot.data ?? [];
//                   return appointments.isEmpty
//                       ? Center(
//                           child: Text(
//                             noAppointmentsBooked,
//                             style: GoogleFonts.schoolbell(
//                                 fontSize: 24.sp,
//                                 color: Color.fromRGBO(67, 44, 0, .3)),
//                           ),
//                         )
//                       : ListView.builder(
//                           itemCount: appointments.length,
//                           itemBuilder: (context, index) {
//                             final appointment =
//                                 appointments.reversed.toList()[index];
//                             return Column(
//                               children: [
//                                 Container(
//                                   child: Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.fromLTRB(
//                                             10, 10, 5, 10),
//                                         child: Icon(
//                                           Icons.calendar_month,
//                                           color: iconColor,
//                                         ),
//                                       ),
//                                       Expanded(
//                                         child: ListTile(
//                                           title: Text(
//                                             'Id :${appointment.id} (${appointment.appointmentDate ?? 'N/A'})',
//                                             style: TextStyle(color: heading),
//                                           ),
//                                           subtitle: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 'Pickup : ${appointment.from ?? "no data"}',
//                                                 style:
//                                                     TextStyle(color: subtext),
//                                               ),
//                                               Text(
//                                                 'No. of people : ${appointment.numOfPeople ?? 'N/A'}',
//                                                 style:
//                                                     TextStyle(color: subtext),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: EdgeInsets.fromLTRB(
//                                             0.sp, 20, 0, 10),
//                                         child: IconButton(
//                                           onPressed: () async {
//                                             showDialog(
//                                               context: context,
//                                               builder: (BuildContext context) {
//                                                 var size = SizedBox(
//                                                   height: 24,
//                                                 );
//                                                 return AlertDialog(
//                                                   backgroundColor:
//                                                       pageBackground,
//                                                   elevation: 4,
//                                                   shadowColor: Color.fromRGBO(
//                                                       186, 26, 26, 1),
//                                                   content: SizedBox(
//                                                     width:
//                                                         MediaQuery.of(context)
//                                                             .size
//                                                             .width,
//                                                     child: Column(
//                                                       mainAxisSize:
//                                                           MainAxisSize.min,
//                                                       children: [
//                                                         size,
//                                                         Image.asset(
//                                                           "assets/images/Alert Delete.png",
//                                                           height: 100.h,
//                                                           width: 100.w,
//                                                           fit: BoxFit.cover,
//                                                         ),
//                                                         size,
//                                                         Text(
//                                                           "Are you sure to delete ? ",
//                                                           style: TextStyle(
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .normal,
//                                                             fontSize: 20.sp,
//                                                           ),
//                                                           textAlign:
//                                                               TextAlign.center,
//                                                         ),
//                                                         SizedBox(
//                                                           height: 16,
//                                                         ),
//                                                         Text(
//                                                           "Booking cancellation occurs when an \nappointment is deleted. ",
//                                                           style: TextStyle(
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .normal,
//                                                             fontSize: 12.sp,
//                                                           ),
//                                                           textAlign:
//                                                               TextAlign.center,
//                                                         ),
//                                                         size,
//                                                         SizedBox(
//                                                           height: 56,
//                                                           child: ElevatedButton(
//                                                             onPressed:
//                                                                 () async {
//                                                               deleteAppointment(context, appointment.id.toString());
//                                                               Navigator.of(
//                                                                       context)
//                                                                   .pop();
//                                                               await fetchAppointments();
//                                                               setState(() {});
//                                                             },
//                                                             style:
//                                                                 ElevatedButton
//                                                                     .styleFrom(
//                                                               primary: Color
//                                                                   .fromRGBO(
//                                                                       186,
//                                                                       26,
//                                                                       26,
//                                                                       1),
//                                                               shape:
//                                                                   RoundedRectangleBorder(
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .circular(
//                                                                             16),
//                                                               ),
//                                                             ),
//                                                             child: Row(
//                                                               mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .center,
//                                                               children: [
//                                                                 Text(
//                                                                   "Confirm",
//                                                                   style: TextStyle(
//                                                                       color: Colors
//                                                                           .white),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         size,
//                                                         TextButton(
//                                                           child: const Text(
//                                                             'Cancel',
//                                                             style: TextStyle(
//                                                                 color: Color
//                                                                     .fromRGBO(
//                                                                         186,
//                                                                         26,
//                                                                         26,
//                                                                         1)),
//                                                           ),
//                                                           onPressed: () {
//                                                             Navigator.of(context).pop();
//                                                           },
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 );
//                                               },
//                                             );
//                                           },
//                                           icon: Icon(Icons.delete,
//                                               color: iconColor),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Divider(
//                                   color: dividerLine,
//                                   thickness: 1,
//                                 ),
//                                 if (index ==
//                                     appointments.length -
//                                         1) // Add SizedBox only for the last item
//                                   SizedBox(height: 70.sp),
//                                 // if (index !=
//                                 //     appointments.length -
//                                 //         1) // Conditionally show divider for items other than the last one
//                                 //   Divider(
//                                 //     color: dividerLine,
//                                 //     thickness: 1,
//                                 //   ),
//                               ],
//                             );
//                           },
//                         );
//                 }
//               },
//             )
//           : Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SvgPicture.asset(
//                     width: 80.w,
//                     height: 80.h,
//                     error,
//                   ),
//                   SizedBox(height: 16.sp),
//                   Text(
//                     somethingWentWrong,
//                     style: TextStyle(
//                         color: appbar,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20.sp),
//                   ),
//                   SizedBox(height: 16.sp),
//                   SizedBox(
//                     width: 130.w,
//                     height: 40.h,
//                     child: OutlinedButton(
//                       onPressed: () async {
//                         checkConnectivity(); // Refresh connectivity status
//                       },
//                       style: OutlinedButton.styleFrom(
//                         backgroundColor: pageBackground,
//                         elevation: 4,
//                         shadowColor: Colors.black,
//                         side: BorderSide(color: Colors.black, width: .7),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(Icons.autorenew, color: appbar),
//                           Text(
//                             'Refresh',
//                             style: TextStyle(
//                                 fontSize: 14.sp,
//                                 fontWeight: FontWeight.bold,
//                                 color: appbar),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: buttonColor,
//         onPressed: () {
//           Navigator.push(
//             context,
//             PageRouteBuilder(
//               transitionDuration: Duration(milliseconds: 500),
//               transitionsBuilder: (BuildContext context,
//                   Animation<double> animation,
//                   Animation<double> secAnimation,
//                   Widget child) {
//                 return SlideTransition(
//                   position: Tween<Offset>(
//                     begin: Offset(1.0, 0.0),
//                     end: Offset.zero,
//                   ).animate(animation),
//                   child: child,
//                 );
//               },
//               pageBuilder: (BuildContext context, Animation<double> animation,
//                   Animation<double> secAnimation) {
//                 return AppointmentPage();
//               },
//             ),
//           );
//         },
//         child: Icon(
//           Icons.add,
//           color: iconColor,
//           size: 35.sp,
//         ),
//       ),
//     );
//   }
// }
