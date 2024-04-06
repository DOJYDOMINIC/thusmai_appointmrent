import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thusmai_appointmrent/controller/login_register_otp_api.dart';
import 'package:thusmai_appointmrent/controller/socket_provider.dart';
import 'package:thusmai_appointmrent/pages/bottom_navbar.dart';
import 'package:thusmai_appointmrent/pages/login_register_otp/login.dart';
import 'package:thusmai_appointmrent/pages/login_register_otp/meditationdata.dart';
import 'controller/appointmentontroller.dart';
import 'controller/connectivitycontroller.dart';
import 'controller/meditationController.dart';
import 'controller/payment_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var cookies = prefs.getString("cookie") ?? "";
  var isAnswered = prefs.getString("isAnswered");
  runApp(MyApp(cookies: cookies,isAnswered: isAnswered,));
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
    this.cookies,
    this.isAnswered,
  }) : super(key: key);
  final cookies;
  final isAnswered;

  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppointmentController(),),
        ChangeNotifierProvider(create: (context) => AppLogin(),),
        ChangeNotifierProvider(create: (context) => SocketProvider(),),
        ChangeNotifierProvider(create: (context) => ConnectivityProvider(),),
        ChangeNotifierProvider(create: (context) => PaymentController(),),
        ChangeNotifierProvider(create: (context) => MeditationController(),),
      ],
      child: ScreenUtilInit(
        designSize: const Size(400, 880),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Roboto'),
            home: widget.cookies == null || widget.cookies == "" ? Login() : widget.isAnswered != "true" ? MeditationData() : CustomBottomNavBar(),
            // home: VideoPalayer(),
          );
        },
      ),
    );
  }
}
