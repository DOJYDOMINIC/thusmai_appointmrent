import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';
import 'package:thusmai_appointmrent/tabs/hometab.dart';
import 'package:thusmai_appointmrent/tabs/messsagetab.dart';
import 'package:thusmai_appointmrent/pages/profile/profile.dart';
import 'package:thusmai_appointmrent/widgets/additionnalwidget.dart';
import '../controller/login_register_otp_api.dart';
import '../services/firebase_notification.dart';
import '../tabs/meditationTab.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({Key? key,}) : super(key: key);
  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {

  @override
  void initState() {
    super.initState();
    FirebaseApi().initNotifications();

  }
  int _currentIndex = 1;
  bool _videoEnabled = true;
  bool _homeEnabled = true;
  bool _meditationEnabled = true;
  bool _paymentsEnabled = true;

  final List<Widget> _pages = [
    Container(
      color: shadeOne,
      child: Center(
          child: Text(
            pageUnderWork,
            style: TextStyle(
                fontSize: 24.sp, color: const Color.fromRGBO(67, 44, 0, .3)),
          )),
    ),
    HomeTab(),
    MeditationTab(),
    Container(
      color: shadeOne,
      child: Center(
          child: Text(
            pageUnderWork,
            style: TextStyle(
                fontSize: 24.sp, color: const Color.fromRGBO(67, 44, 0, .3)),
          )),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    // var pro = Provider.of<AppointmentController>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkShade,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image(
            image: AssetImage(logo),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MessageTab(),));
            },
            icon: Icon(
              Icons.message_outlined,
              color: shadeSix,
            ),
          ),
          IconButton(
            onPressed: () {
            },
            icon: Icon(
              Icons.circle_notifications_outlined,
              color: shadeSix,
            ),
          ),
          IconButton(
            onPressed: () {
              Provider.of<AppLogin>(context,listen: false).getUserByID();
              slidePageRoute(context,Profile());
              // Navigator.push(
              //   context,
              //   PageRouteBuilder(
              //     transitionDuration: Duration(milliseconds: 500),
              //     transitionsBuilder: (BuildContext context,
              //         Animation<double> animation,
              //         Animation<double> secAnimation,
              //         Widget child) {
              //       return SlideTransition(
              //         position: Tween<Offset>(
              //           begin: Offset(1.0, 0.0),
              //           end: Offset.zero,
              //         ).animate(animation),
              //         child: child,
              //       );
              //     },
              //     pageBuilder: (BuildContext context,
              //         Animation<double> animation,
              //         Animation<double> secAnimation) {
              //       return Profile();
              //     },
              //   ),
              // );
            },
            icon: Icon(
              Icons.account_circle,
              color: shadeSix,
            ),
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar:  Container(
        height: 80,
        color: darkShade, // Background color of the bottom navigation bar
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildNavBarItem(_currentIndex != 0?Icons.videocam_outlined: Icons.videocam, videos, 0,_videoEnabled),
            buildNavBarItem(_currentIndex != 1 ?Icons.home_outlined :Icons.home_rounded , home, 1,_homeEnabled),
            buildNavBarItem(Icons.self_improvement, meditation, 2,_meditationEnabled),
            buildNavBarItem(_currentIndex != 3 ?Icons.payments_outlined:Icons.payments_rounded, payment, 3,_paymentsEnabled),
          ],
        ),
      ),
    );
  }
  Widget buildNavBarItem(IconData icon, String label, int index,bool isEnabled,) {
    return GestureDetector(
      onTap:isEnabled
          ? () {
        setState(() {
          _currentIndex = index;
        });
      }
          : (){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(enable)));
        if (isEnabled == false) {
          _currentIndex = 3; // Navigate to index 0 when tapping on index 3
          setState(() {
          });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 4, // Divide by number of items
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64.w,
              height: 32.h,
              decoration: BoxDecoration(color:_currentIndex == index ? shadeEleven : darkShade,borderRadius: BorderRadius.circular(20.sp) ),
              child: Icon(
                icon,
                color:isEnabled? _currentIndex == index ? shadeSix: shadeFive : Colors.grey, // Icon color
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color:isEnabled?  _currentIndex == index ? shadeTwo : shadeFive : Colors.grey, // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}