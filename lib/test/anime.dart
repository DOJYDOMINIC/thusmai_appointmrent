// // import 'package:flutter_background_service/flutter_background_service.dart';
// // import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
// //
// // class BackgroundService {
// //   static final FlutterBackgroundService service = FlutterBackgroundService();
// //
// //   static Future<void> initializeBackgroundService() async {
// //     await service.configure(
// //       androidConfiguration: AndroidConfiguration(
// //         onStart: onStart,
// //         autoStart: true,
// //         isForegroundMode: true,
// //       ),
// //       iosConfiguration: IosConfiguration(
// //         autoStart: true,
// //         onForeground: onStart,
// //         onBackground: onIosBackground,
// //       ),
// //     );
// //     await service.startService();
// //   }
// //
// //   static void onStart(Map<String, dynamic>? params) async{
// //     print('Background service started');
// //     // Schedule the alarm
// //     await AndroidAlarmManager.oneShot(
// //       Duration(minutes: 45), // Set the alarm for 45 minutes from now
// //       12345, // Unique ID for the alarm
// //       callbackFunction, // Callback function to execute when the alarm fires
// //       wakeup: true, // Ensure the app wakes up to handle the alarm
// //     );
// //   }
// //
// //   static void callbackFunction() {
// //     print('Alarm fired!');
// //     // Play the alarm sound here
// //   }
// //
// //   static void onIosBackground(Map<String, dynamic>? params) {
// //     print('iOS background task started');
// //     // Implement iOS background task logic here
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
//
//
// class StartAlm extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text('Timer and Alarm Example')),
//         body: Center(child: Text('Press the button to start the timer')),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             print("pressed");
//             startTimerAndScheduleAlarm();
//           },
//           child: Icon(Icons.timer),
//         ),
//       ),
//     );
//   }
//
//   void startTimerAndScheduleAlarm() async {
//     // Schedule the alarm to fire after 45 minutes
//     await AndroidAlarmManager.oneShot(
//       Duration(minutes: 1),
//       0, // Unique ID for the alarm
//       callbackFunction, // Callback function to execute when the alarm fires
//       wakeup: true, // Ensure the app wakes up to handle the alarm
//     );
//   }
//
//   void callbackFunction() {
//     print('Alarm fired!');
//     // Here, you can play a sound or show a notification
//     showNotification();
//   }
//
//   void showNotification() async {
//     // Initialize the notification plugin
//     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
//
//     // Initialize settings for Android
//     var android = AndroidInitializationSettings('@drawable/ic_launcher');
//     var initializationSettings = InitializationSettings(android: android);
//
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//
//     // Define the notification details
//     var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'high_importance_channel',
//       'High Importance Notifications',
//       importance: Importance.high,
//       priority: Priority.high,
//       playSound: true,
//       icon: '@drawable/ic_launcher', // Replace with your app's launcher icon
//     );
//
//     var platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//     );
//
//     // Show the notification
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       'Reminder',
//       'It\'s time for your task!',
//       platformChannelSpecifics,
//       payload: 'item x',
//     );
//   }
// }

// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// import 'dart:developer' as developer;
// import 'dart:isolate';
// import 'dart:math';
// import 'dart:ui';
//
// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/material.dart';
//
// /// The [SharedPreferences] key to access the alarm fire count.
// const String countKey = 'count';
//
// /// The name associated with the UI isolate's [SendPort].
// const String isolateName = 'isolate';
//
// /// A port used to communicate from a background isolate to the UI isolate.
// ReceivePort port = ReceivePort();
//
// /// Global [SharedPreferences] object.
// SharedPreferences? prefs;
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
// // Register the UI isolate's SendPort to allow for communication from the
// // background isolate.
//   IsolateNameServer.registerPortWithName(
//     port.sendPort,
//     isolateName,
//   );
//   prefs = await SharedPreferences.getInstance();
//   if (!prefs!.containsKey(countKey)) {
//     await prefs!.setInt(countKey, 0);
//   }
//
//   runApp(const AlarmManagerExampleApp());
// }
//
// /// Example app for Espresso plugin.
// class AlarmManagerExampleApp extends StatelessWidget {
//   const AlarmManagerExampleApp({super.key});
//
// // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         useMaterial3: true,
//         colorSchemeSeed: const Color(0x9f4376f8),
//       ),
//       home: const _AlarmHomePage(),
//     );
//   }
// }
//
// class _AlarmHomePage extends StatefulWidget {
//   const _AlarmHomePage();
//
//   @override
//   _AlarmHomePageState createState() => _AlarmHomePageState();
// }
//
// class _AlarmHomePageState extends State<_AlarmHomePage> {
//   int _counter = 0;
//   PermissionStatus _exactAlarmPermissionStatus = PermissionStatus.granted;
//
//   @override
//   void initState() {
//     super.initState();
//     AndroidAlarmManager.initialize();
//     _checkExactAlarmPermission();
//
// // Register for events from the background isolate. These messages will
// // always coincide with an alarm firing.
//     port.listen((_) async => await _incrementCounter());
//   }
//
//   void _checkExactAlarmPermission() async {
//     final currentStatus = await Permission.scheduleExactAlarm.status;
//     setState(() {
//       _exactAlarmPermissionStatus = currentStatus;
//     });
//   }
//
//   Future<void> _incrementCounter() async {
//     developer.log('Increment counter!');
// // Ensure we've loaded the updated count from the background isolate.
//     await prefs?.reload();
//
//     setState(() {
//       _counter++;
//     });
//   }
//
// // The background
//   static SendPort? uiSendPort;
//
// // The callback for our alarm
//   @pragma('vm:entry-point')
//   static Future<void> callback() async {
//     developer.log('Alarm fired!');
// // Get the previous cached count and increment it.
//     final prefs = await SharedPreferences.getInstance();
//     final currentCount = prefs.getInt(countKey) ?? 0;
//     await prefs.setInt(countKey, currentCount + 1);
//
// // This will be null if we're running in the background.
//     uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
//     uiSendPort?.send(null);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final textStyle = Theme.of(context).textTheme.headlineMedium;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Android alarm manager plus example'),
//         elevation: 4,
//       ),
//       body: Center(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Spacer(),
//             Text(
//               'Alarms fired during this run of the app: $_counter',
//               style: textStyle,
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Total alarms fired since app installation: ${prefs?.getInt(countKey).toString() ?? ''}',
//               style: textStyle,
//               textAlign: TextAlign.center,
//             ),
//             const Spacer(),
//             if (_exactAlarmPermissionStatus.isDenied)
//               Text(
//                 'SCHEDULE_EXACT_ALARM is denied\n\nAlarms scheduling is not available',
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context).textTheme.titleMedium,
//               )
//             else
//               Text(
//                 'SCHEDULE_EXACT_ALARM is granted\n\nAlarms scheduling is available',
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context).textTheme.titleMedium,
//               ),
//             const SizedBox(height: 32),
//             ElevatedButton(
//               onPressed: _exactAlarmPermissionStatus.isDenied
//                   ? () async {
//                       await Permission.scheduleExactAlarm
//                           .onGrantedCallback(() => setState(() {
//                                 _exactAlarmPermissionStatus =
//                                     PermissionStatus.granted;
//                               }))
//                           .request();
//                     }
//                   : null,
//               child: const Text('Request exact alarm permission'),
//             ),
//             const SizedBox(height: 32),
//             ElevatedButton(
//               onPressed: _exactAlarmPermissionStatus.isGranted
//                   ? () async {
//                       await AndroidAlarmManager.oneShot(
//                         const Duration(seconds: 15),
// // Ensure we have a unique alarm ID.
//                         Random().nextInt(pow(2, 31) as int),
//                         callback,
//                         exact: true,
//                         wakeup: true,
//                       );
//                     }
//                   : null,
//               child: const Text('Schedule OneShot Alarm'),
//             ),
//             const Spacer(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class TimeProgressWidget extends StatefulWidget {
//   final String startTime;
//   final String endTime;
//
//   TimeProgressWidget({Key? key, required this.startTime, required this.endTime})
//       : super(key: key);
//
//   @override
//   _TimeProgressWidgetState createState() => _TimeProgressWidgetState();
// }
//
// class _TimeProgressWidgetState extends State<TimeProgressWidget> {
//   late DateTime startDateTime;
//   late DateTime endDateTime;
//   double progress = 0.0;
//
//   @override
//   void initState() {
//     super.initState();
//     startDateTime = DateFormat('h:mm a').parse(widget.startTime);
//     endDateTime = DateFormat('h:mm a').parse(widget.endTime);
//
//     // Calculate initial progress
//     updateProgress();
//
//     // Update progress every second
//     Timer.periodic(const Duration(seconds: 1), (Timer t) => updateProgress());
//   }
//
//   void updateProgress() {
//     DateTime now = DateTime.now();
//     if (now.isAfter(startDateTime) && now.isBefore(endDateTime)) {
//       // Calculate total duration in seconds
//       double totalDurationSeconds =
//       endDateTime.difference(startDateTime).inSeconds.toDouble();
//
//       // Calculate elapsed duration in seconds
//       double elapsedDurationSeconds =
//       now.difference(startDateTime).inSeconds.toDouble();
//
//       // Calculate progress
//       setState(() {
//         progress = elapsedDurationSeconds / totalDurationSeconds;
//       });
//     } else if (now.isAfter(endDateTime)) {
//       // If current time is after end time, progress is complete (1.0)
//       setState(() {
//         progress = 1.0;
//       });
//     } else if (now.isBefore(startDateTime)) {
//       // If current time is before start time, progress is 0.0
//       setState(() {
//         progress = 0.0;
//       });
//     }
//
//     // Limit progress to 0.5 if current time is halfway between start and end
//     if (now.isAfter(startDateTime) &&
//         now.isBefore(endDateTime) &&
//         progress > 0.5) {
//       setState(() {
//         progress = 0.5;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           LinearProgressIndicator(
//             value: progress,
//             backgroundColor: Colors.grey,
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//           ),
//           SizedBox(height: 10.0),
//           Text(
//             'Progress: ${progress.toStringAsFixed(1)}',
//             style: TextStyle(fontSize: 20.0),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
//
//
//
//
