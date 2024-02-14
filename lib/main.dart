import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';
import 'controller/appointment_controller.dart';
import 'pages/hometab.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppointmentProvider(),
        ),
      ],
      child: Consumer(
        builder: (BuildContext context, value, Widget? child) => ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (_, __) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  fontFamily: 'Roboto',
                  colorScheme: ColorScheme(
                    background: pageBackground,
                    brightness: Brightness.light, // Set brightness as needed
                    primary: Colors.black, // Set primary color as needed
                    onPrimary: Colors.black, // Set text color on primary color as needed
                    secondary: Colors.red, // Set secondary color as needed
                    onSecondary: Colors.black, // Set text color on secondary color as needed
                    error: Colors.red, // Set error color as needed
                    onError: Colors.white, // Set text color on error color as needed
                    onBackground: Colors.black, // Set text color on background color as needed
                    surface: Colors.white, // Set surface color as needed
                    onSurface: Colors.black, // Set text color on surface color as needed
                  ),                ),
                home: HomeTab(),
              );
            }),
      ),
    );
  }
}
