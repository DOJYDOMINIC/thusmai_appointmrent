import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thusmai_appointmrent/constant/appointment_constant.dart';
import 'package:thusmai_appointmrent/pages/hometab.dart';
import 'package:thusmai_appointmrent/pages/message/message_guru.dart';
import 'package:thusmai_appointmrent/pages/message/messsagetab.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({Key? key}) : super(key: key);

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _currentIndex = 1;
  final List<Widget> _pages = [
    MessageTab(),
    HomeTab(),
    Container(
      color: pageBackground,
      child: Center(
          child: Text(
            pageUnderWork,
            style: GoogleFonts.schoolbell(
                fontSize: 24.sp, color: Color.fromRGBO(67, 44, 0, .3)),
          )),
    ),
    Container(
      color: pageBackground,
      child: Center(
          child: Text(
            pageUnderWork,
            style: GoogleFonts.schoolbell(
                fontSize: 24.sp, color: Color.fromRGBO(67, 44, 0, .3)),
          )),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbar,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image(
            image: AssetImage(logo),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {

            },
            icon: Icon(
              Icons.circle_notifications_outlined,
              color: iconColor,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.account_circle,
              color: iconColor,
            ),
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        height: 80,
        color: appbar, // Background color of the bottom navigation bar
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildNavBarItem(Icons.comment, "Message", 0),
            buildNavBarItem(Icons.home_filled, "Home", 1),
            buildNavBarItem(Icons.self_improvement, "Meditation", 2),
            buildNavBarItem(Icons.payments_outlined, "Payments", 3),
          ],
        ),
      ),
    );
  }

  Widget buildNavBarItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 4, // Divide by number of items
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64.w,
              height: 32.h,
              decoration: BoxDecoration(color:_currentIndex == index ? iconContainer : appbar,borderRadius: BorderRadius.circular(20.sp) ),
              child: Icon(
                icon,
                color: _currentIndex == index ? navIcon: bottomNavLabelUnSelected, // Icon color
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: _currentIndex == index ? bottomNavLabel : bottomNavLabelUnSelected, // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
