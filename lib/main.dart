import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thusmai_appointmrent/pages/appointment/appointment_add.dart';
import 'package:thusmai_appointmrent/pages/login_register_otp/login.dart';
import 'package:thusmai_appointmrent/services/firebase_notification.dart';
import 'bottom_navbar.dart';
import 'controller/providerdata.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var cookies = prefs.getString("cookie")??"";
  runApp(MyApp(cookies : cookies));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, this.cookies,}) : super(key: key);
  final cookies;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  void handleNotification(RemoteMessage message) {
    if (message == null) return;
    // Extract any data from the notification
    final notificationData = message.data;
    // Check if there is a specific action to take based on the notification data
    if (notificationData != null && notificationData['navigateTo'] == 'appointment') {
      // If the notification data specifies to navigate to the details page, push the route
      Navigator.push(context, MaterialPageRoute(builder: (context) => AppointmentPage(),));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProviderController(),
        ),
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
            home: widget.cookies == null || widget.cookies == "" ?  Login() :CustomBottomNavBar() ,
            // home: Register(),
          );
        },
      ),
    );
  }
}
