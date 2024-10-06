import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:thusmai_appointmrent/login/new_login.dart';
import 'package:thusmai_appointmrent/health/guruji_questions.dart';
import 'package:thusmai_appointmrent/health/stress_data.dart';
import 'package:thusmai_appointmrent/services/firebase_notification.dart';
import 'package:workmanager/workmanager.dart';
import 'constant/constant.dart';
import 'controller/disable_meditation.dart';
import 'controller/healt_controller.dart';
import 'controller/login_register_otp_api.dart';
import 'controller/timer_controller.dart';
import 'controller/zoommeeting_controller.dart';
import 'models/hive/meditationdata.dart';
import 'pages/bottom_navbar.dart';
import 'controller/appointmentontroller.dart';
import 'controller/meditationController.dart';
import 'controller/message_controller.dart';
import 'controller/overviewController.dart';
import 'controller/payment_controller.dart';
import 'controller/profileController.dart';
import 'controller/videoplayer_controller.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentSeconds = prefs.getInt('currentSeconds') ?? 0;
    if (currentSeconds > 0) {
      currentSeconds--;
      prefs.setInt('currentSeconds', currentSeconds);
    }
    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MeditationDataAdapter());
  await Hive.openBox<MeditationData>('MeditationDataBox');
  await Firebase.initializeApp();
  FirebaseApi().initNotifications();
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var cookies = prefs.getString("cookie") ?? "1";
  var isAnswered = prefs.getString("isAnswered");

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
    runApp(MyApp(cookies: cookies, isAnswered: isAnswered));
  });
}

class MyApp extends StatelessWidget {
  final String? cookies;
  final String? isAnswered;

  const MyApp({Key? key, this.cookies, this.isAnswered,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppointmentController()),
        ChangeNotifierProvider(create: (context) => AppLogin()),
        // ChangeNotifierProvider(create: (context) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (context) => PaymentController()),
        ChangeNotifierProvider(create: (context) => MeditationController()),
        ChangeNotifierProvider(create: (context) => VideoPlayerStateController()),
        ChangeNotifierProvider(create: (context) => MessageController()),
        ChangeNotifierProvider(create: (context) => OverViewController()),
        ChangeNotifierProvider(create: (context) => ProfileController()),
        ChangeNotifierProvider(create: (context) => ZoomMeetingController()),
        ChangeNotifierProvider(create: (context) => ButtonStateNotifier()),
        ChangeNotifierProvider(create: (_) => TimerProvider()),
        ChangeNotifierProvider(create: (_) => HealthController()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(400, 880),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'Roboto'),
            initialRoute: '/', // Set initial route to '/'
            routes: {
              '/': (context) => SplashScreen(),
              // Define '/' route to SplashScreen
              '/home': (context) => cookies!.length > 4 && cookies != "1"
                  ? CustomBottomNavBar()
                  : LoginUpdate(),
            },
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _logoScale = 1.0; // Initial scale
  bool _showBothLogos = false;
  Timer? _navigationTimer;
  Timer? _logoTimer;
  Timer? _hideLogosTimer;

  @override
  void initState() {
    super.initState();
    Provider.of<AppLogin>(context, listen: false).listQuestions();
    // Navigate after 2 seconds
    _navigationTimer = Timer(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/home');
    });

    // Show both logos together for 2 seconds after the first logo animation completes
    _logoTimer = Timer(Duration(seconds: 2), () {
      setState(() {
        _showBothLogos = true;
      });
      _hideLogosTimer = Timer(Duration(seconds: 2), () {
        setState(() {
          _showBothLogos = false;
        });
      });
    });
  }

  @override
  void dispose() {
    // Cancel the timers to avoid any potential memory leaks
    _navigationTimer?.cancel();
    _logoTimer?.cancel();
    _hideLogosTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 2.0, end: 0.5), // Define the scale range
          duration: const Duration(seconds: 1), // Duration for the animation
          builder: (BuildContext context, double value, Widget? child) {
            if (value == 0.5) {
              // When zoomed out, push the first logo to the left
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.translate(
                    offset: Offset(-10, 0),
                    child: Transform.scale(
                      scale: value,
                      child: child,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(-0, 0),
                    child: Image.asset(
                      stars_80vector,
                      // Replace with the path to the second logo
                      height: 52.h,
                    ),
                  ),
                ],
              );
            } else {
              // When zooming in or out, show the first logo
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: value,
                    child: child,
                  ),
                  if (_showBothLogos)
                    Image.asset(
                      stars_80vector,
                      // Replace with the path to the second logo
                      height: 52.h,
                    ),
                ],
              );
            }
          },
          child: Image.asset(
            logo, // Replace with the path to your logo
            height: 100,
          ),
        ),
      ),
    );
  }
}
