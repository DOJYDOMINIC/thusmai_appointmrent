import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';
import 'package:thusmai_appointmrent/pages/hometab.dart';
import 'package:thusmai_appointmrent/pages/login_register_otp/login.dart';
import 'package:thusmai_appointmrent/pages/message/messsagetab.dart';
import 'package:thusmai_appointmrent/pages/rasorpay.dart';

import 'controller/providerdata.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({Key? key,}) : super(key: key);
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
                fontSize: 24.sp, color: const Color.fromRGBO(67, 44, 0, .3)),
          )),
    ),
    PaymentPage(title: 'Payment',),
    // Container(
    //   color: pageBackground,
    //   child: Center(
    //       child: Text(
    //         pageUnderWork,
    //         style: GoogleFonts.schoolbell(
    //             fontSize: 24.sp, color: Color.fromRGBO(67, 44, 0, .3)),
    //       )),
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ProviderController>(context);
    return Scaffold(
      appBar:_currentIndex != 0 ? AppBar(
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
              color: navIcon,
            ),
          ),
          IconButton(
            onPressed: () async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(),));
            },
            icon: Icon(
              Icons.account_circle,
              color: navIcon,
            ),
          ),
        ],
      ):AppBar(
        backgroundColor: appbar,
        title: Text(pro.messageTabHead.toString(),style: TextStyle(color: Colors.white),),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CustomBottomNavBar(),));
          }, icon: Icon(Icons.arrow_back,color: Colors.white,),),
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: _currentIndex == 0 ? null : Container(
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