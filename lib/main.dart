import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:thusmai_appointmrent/services/firebase_notification.dart';
import 'controller/login_register_otp_api.dart';
import 'controller/timerprovidedr.dart';
import 'controller/zoommeeting_controller.dart';
import 'pages/bottom_navbar.dart';
import 'pages/login_register_otp/login.dart';
import 'controller/appointmentontroller.dart';
import 'controller/connectivitycontroller.dart';
import 'controller/meditationController.dart';
import 'controller/message_controller.dart';
import 'controller/overviewController.dart';
import 'controller/payment_controller.dart';
import 'controller/profileController.dart';
import 'controller/videoplayer_controller.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseApi().initNotifications();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var cookies = prefs.getString("cookie")??"1";
  var isAnswered = prefs.getString("isAnswered");
  // await AndroidAlarmManager.initialize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(MyApp(cookies: cookies, isAnswered: isAnswered));
  });
}

class MyApp extends StatelessWidget {
  final String? cookies;
  final String? isAnswered;

  const MyApp({
    Key? key,
    this.cookies,
    this.isAnswered,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppointmentController()),
        ChangeNotifierProvider(create: (context) => AppLogin()),
        ChangeNotifierProvider(create: (context) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (context) => PaymentController()),
        ChangeNotifierProvider(create: (context) => MeditationController()),
        ChangeNotifierProvider(create: (context) => VideoPlayerStateController()),
        ChangeNotifierProvider(create: (context) => MessageController()),
        ChangeNotifierProvider(create: (context) => OverViewController()),
        ChangeNotifierProvider(create: (context) => ProfileController()),
        ChangeNotifierProvider(create: (context) => ZoomMeetingController()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(400, 880),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'Roboto'
            ),
            home: cookies!.length > 4 && cookies != "1" ?  CustomBottomNavBar() : Login(),
          );
        },
      ),
    );
  }
}

