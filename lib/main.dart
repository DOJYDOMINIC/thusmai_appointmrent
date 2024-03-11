import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thusmai_appointmrent/controller/login_register_otp_api.dart';
import 'package:thusmai_appointmrent/controller/socket_provider.dart';
import 'package:thusmai_appointmrent/pages/bottom_navbar.dart';
import 'package:thusmai_appointmrent/pages/login_register_otp/login.dart';
import 'package:thusmai_appointmrent/pages/message/socket_io.dart';
// import 'package:thusmai_appointmrent/pages/message/message_guru.dart';
// import 'package:thusmai_appointmrent/pages/message/socket_io.dart';
import 'package:thusmai_appointmrent/services/firebase_notification.dart';
import 'controller/appointmentontroller_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // await FirebaseApi().initNotifications();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var cookies = prefs.getString("cookie") ?? "";
  runApp(MyApp(cookies: cookies));
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
    this.cookies,
  }) : super(key: key);
  final cookies;

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
      ],
      child: ScreenUtilInit(
        designSize: const Size(400, 880),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Roboto',
            ),
            home: widget.cookies == null || widget.cookies == ""
                ? Login()
                : CustomBottomNavBar(),
            // home: ChatScreen(),
          );
        },
      ),
    );
  }
}
