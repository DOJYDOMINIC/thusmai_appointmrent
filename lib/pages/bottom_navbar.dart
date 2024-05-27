import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';
import 'package:thusmai_appointmrent/pages/videos/videospage.dart';
import 'package:thusmai_appointmrent/pages/videos/videospageone.dart';
import 'package:thusmai_appointmrent/tabs/hometab.dart';
import 'package:thusmai_appointmrent/tabs/messsagetab.dart';
import 'package:thusmai_appointmrent/pages/profile/profile.dart';
import 'package:thusmai_appointmrent/widgets/additionnalwidget.dart';
import '../controller/login_register_otp_api.dart';
import '../services/firebase_notification.dart';
import '../tabs/meditationTab.dart';
import '../tabs/paymentTab.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({
    Key? key,
  }) : super(key: key);

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
  bool _meditationEnabled = false;
  bool _paymentsEnabled = true;

  final List<Widget> _pages = [
    VideosPageOne(),
    HomeTab(),
    MeditationTab(),
    PaymentTab(),
  ];

  void onPopInvoked(bool didPop) {
    if (didPop) {
      return;
    } else if (_currentIndex != 1) {
      setState(() {
        _currentIndex = 1;
      });
    } else if (_currentIndex == 1) {
      showExitConfirmationDialog(context);
    }
  }

  void showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Exit App"),
          content: Text("Are you sure you want to exit the app?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                SystemNavigator.pop(); // Exit the app
              },
              child: Text("Exit"),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    var flagModel = Provider.of<AppLogin>(context).flagModel;
    _meditationEnabled = flagModel.meditationFeePaymentStatus??false;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop)=>onPopInvoked(didPop),
      child: Scaffold(
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
              onPressed: ()=>flagModel.meditationFeePaymentStatus == true ? slidePageRoute(context, MessageTab()):  ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(enableMessage),
                  duration: Duration(seconds: 2),
                ),),
              icon: Icon(
                Icons.message_outlined,
                color: flagModel.meditationFeePaymentStatus == true ?shadeSix : Colors.grey,
              ),
            ),
            // IconButton(
            //   onPressed: () {
            //     slidePageRoute(context, NotificationPage());
            //   },
            //   icon: Icon(
            //     Icons.circle_notifications_outlined,
            //     color: shadeSix,
            //   ),
            // ),
            IconButton(
              onPressed: () {
                Provider.of<AppLogin>(context, listen: false).getUserByID();
                slidePageRoute(context, Profile());
              },
              icon: Icon(
                Icons.account_circle,
                color: shadeSix,
              ),
            ),
          ],
        ),
        body: _pages[_currentIndex],
        bottomNavigationBar: Container(
          height: 80,
          color: darkShade, // Background color of the bottom navigation bar
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildNavBarItem(
                  _currentIndex != 0 ? Icons.videocam_outlined : Icons.videocam,
                  videos,
                  0,
                  _videoEnabled),
              buildNavBarItem(
                  _currentIndex != 1 ? Icons.home_outlined : Icons.home_rounded,
                  home,
                  1,
                  _homeEnabled),
              buildNavBarItem(
                  Icons.self_improvement, meditation, 2, _meditationEnabled),
              buildNavBarItem(
                  _currentIndex != 3
                      ? Icons.payments_outlined
                      : Icons.payments_rounded,
                  payment,
                  3,
                  _paymentsEnabled),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNavBarItem(
    IconData icon,
    String label,
    int index,
    bool isEnabled,
  ) {
    return GestureDetector(
      onTap: isEnabled
          ? () {
              setState(() {
                _currentIndex = index;
              });
            }
          : () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(enable),duration: Duration(seconds: 2),));
              if (isEnabled == false) {
                _currentIndex =
                    3; // Navigate to index 0 when tapping on index 3
                setState(() {});
              }
            },
      child: Container(
        width:
            MediaQuery.of(context).size.width / 4, // Divide by number of items
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64.w,
              height: 32.h,
              decoration: BoxDecoration(
                  color: _currentIndex == index ? shadeEleven : darkShade,
                  borderRadius: BorderRadius.circular(20.sp)),
              child: Icon(
                icon,
                color: isEnabled
                    ? _currentIndex == index
                        ? shadeSix
                        : shadeFive
                    : Colors.grey, // Icon color
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: isEnabled
                    ? _currentIndex == index
                        ? shadeTwo
                        : shadeFive
                    : Colors.grey, // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
