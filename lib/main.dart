import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controller/appointment_controller.dart';
import 'pages/hometab.dart';

String phone = "";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
   phone = prefs.getString("phone") ?? ''; // Provide a default value if phone is null
  runApp(MyApp(phone: phone));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.phone}) : super(key: key);
  final String phone;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppointmentProvider(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Roboto',
            ),
            home: HomeTab(),
          );
        },
      ),
    );
  }
}
