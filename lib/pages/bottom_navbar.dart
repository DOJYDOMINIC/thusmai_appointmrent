import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';
import 'package:thusmai_appointmrent/pages/videos/videospageone.dart';
import 'package:thusmai_appointmrent/tabs/hometab.dart';
import 'package:thusmai_appointmrent/tabs/messsagetab.dart';
import 'package:thusmai_appointmrent/pages/profile/profile.dart';
import 'package:thusmai_appointmrent/widgets/additionnalwidget.dart';
import '../controller/login_register_otp_api.dart';
import '../health/health_page.dart';
import '../services/firebase_notification.dart';
import '../services/permition_service.dart';
import '../tabs/meditationTab.dart';
import '../tabs/paymentTab.dart';
import '../widgets/popup_widget.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({
    super.key,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  void initState() {
    super.initState();
    requestPermissions();
    FirebaseApi().initNotifications();
    Provider.of<AppLogin>(context, listen: false)
        .importantFlags()
        .then((value) {
      Future.delayed(Duration(seconds: 1), () {
        final indexProvider = Provider.of<AppLogin>(context, listen: false);
        if (Provider.of<AppLogin>(context, listen: false)
                .flagModel
                .maintenancePaymentStatus ==
            false) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: SizedBox(
                  height: 350.h,
                  child: PopupWidget(
                    heading: 'Payment Reminder',
                    subHeading: 'Maintenance Payment',
                    amount: "500 INR",
                    buttonOneText: 'Pay now',
                    buttonTwoText: 'Pay later',
                    onPressOne: () {
                      indexProvider.currentIndex = 4;
                      Navigator.pop(context);
                    },
                    onPressTwo: () {
                      Navigator.pop(context);
                    },
                    icon: Icons.self_improvement,
                    buttonColorOne: goldShade,
                    buttonColorTwo: shadeOne,
                  ),
                ),
              );
            },
          );
        }
      });
    });
  }

  bool _videoEnabled = true;
  bool _homeEnabled = true;
  bool _meditationEnabled = true;
  bool _paymentsEnabled = true;

  final List<Widget> _pages = [
    HomeTab(),
    VideosPageOne(),
    MeditationTab(),
    MessageTab(),
    PaymentTab(),
  ];

  void onPopInvoked(BuildContext context, bool didPop) {
    final indexProvider = Provider.of<AppLogin>(context, listen: false);
    if (didPop) {
      return;
    } else if (indexProvider.currentIndex != 0) {
      indexProvider.currentIndex = 0;
    } else if (indexProvider.currentIndex == 0) {
      showExitConfirmationDialog(context);
    }
  }

  void showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 350.h,
            child: PopupWidget(
              heading: 'Exit',
              subHeading: 'Are you sure you want to exit the app?',
              amount: "",
              buttonOneText: 'Exit',
              buttonTwoText: 'Cancel',
              icon: Icons.exit_to_app,
              buttonColorOne: darkShade,
              onPressOne: () {
                Navigator.of(context).pop(); // Close the dialog
                SystemNavigator.pop(); // Ex
              },
              onPressTwo: () {
                Navigator.pop(context);
              },
              buttonColorTwo: shadeOne,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var flagModel = Provider.of<AppLogin>(context).flagModel;
    var indexProvider = Provider.of<AppLogin>(context);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => onPopInvoked(context, didPop),
      child: Scaffold(
        backgroundColor: darkShade,
        appBar: AppBar(
          backgroundColor: darkShade,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image(
              image: AssetImage(logo),
            ),
          ),
          actions: [
            // IconButton(
            //   onPressed: () {
            //     if (flagModel.maintenancePaymentStatus == true ||
            //         flagModel.meditationFeePaymentStatus == true) {
            //       slidePageRoute(context, MessageTab());
            //     } else {
            //       Provider.of<AppLogin>(context, listen: false).currentIndex =
            //           3;
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         SnackBar(
            //           backgroundColor: Colors.red,
            //           content: Text(enableMessage),
            //           duration: Duration(seconds: 2),
            //         ),
            //       );
            //     }
            //   },
            //   icon: Icon(
            //     Icons.medical_services_rounded,
            //     color: flagModel.maintenancePaymentStatus == true ||
            //             flagModel.meditationFeePaymentStatus == true
            //         ? shadeSix
            //         : Colors.grey,
            //   ),
            // ),

            // IconButton(
            //   onPressed: () {
            //     slidePageRoute(context, NotificationPage());
            //   },
            //   icon: Icon(
            //     Icons.notifications_active_outlined,
            //     color: shadeSix,
            //   ),
            // ),
            GestureDetector(
              onTap: () {
                launchURL(Uri.parse("https://starlife.co.in/health/"));

                // Navigator.push(context, MaterialPageRoute(builder: (context) => WebView(),));
              },
              child: SvgPicture.asset(
                "assets/svgImage/shield_with_heart.svg",
              ),
            ),
            SizedBox(
              width: 32.sp,
            ),
            GestureDetector(
              onTap: () {},
              child: SvgPicture.asset("assets/svgImage/note.svg"),
            ),
            // IconButton(
            //   onPressed: () {
            //     Provider.of<AppLogin>(context, listen: false).getUserByID();
            //     slidePageRoute(context, Profile());
            //   },
            //   icon: Icon(
            //     Icons.note_alt_rounded,
            //     color: shadeSix,
            //   ),
            // ),
            SizedBox(
              width: 8.sp,
            ),
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
        body: _pages[indexProvider.currentIndex],
        bottomNavigationBar: Container(
          height: 80,
          color: darkShade, // Background color of the bottom navigation bar
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildNavBarItem(
                  currentIndex: indexProvider.currentIndex,
                  icon: indexProvider.currentIndex != 0
                      ? Icons.home_outlined
                      : Icons.home_rounded,
                  label: home,
                  index: 0,
                  isEnabled: _homeEnabled),
              buildNavBarItem(
                  currentIndex: indexProvider.currentIndex,
                  icon: indexProvider.currentIndex != 1
                      ? Icons.videocam_outlined
                      : Icons.videocam,
                  label: videos,
                  index: 1,
                  isEnabled: _videoEnabled),
              buildNavBarItem(
                  currentIndex: indexProvider.currentIndex,
                  icon: Icons.self_improvement,
                  label: meditation,
                  index: 2,
                  isEnabled: _meditationEnabled),
              buildNavBarItem(
                  currentIndex: indexProvider.currentIndex,
                  icon: Icons.chat_outlined,
                  label: message,
                  index: 3,
                  isEnabled: _meditationEnabled),
              buildNavBarItem(
                  currentIndex: indexProvider.currentIndex,
                  icon: indexProvider.currentIndex != 3
                      ? Icons.payments_outlined
                      : Icons.payments_rounded,
                  label: payment,
                  index: 4,
                  isEnabled: _paymentsEnabled),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNavBarItem({
    required int currentIndex,
    required IconData icon,
    required String label,
    required int index,
    required bool isEnabled,
  }) {
    return GestureDetector(
      onTap: isEnabled
          ? () {
              Provider.of<AppLogin>(context, listen: false).currentIndex =
                  index;
            }
          : () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(enable),
                  duration: Duration(seconds: 2),
                ),
              );
            },
      child: Container(
        width:
            MediaQuery.of(context).size.width / 5, // Divide by number of items
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: currentIndex == index ? shadeEleven : darkShade,
                borderRadius: BorderRadius.circular(20.sp),
              ),
              child: Icon(
                icon,
                color: isEnabled
                    ? currentIndex == index
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
                    ? currentIndex == index
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

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:thusmai_appointmrent/constant/constant.dart';
// import 'package:thusmai_appointmrent/pages/videos/videospageone.dart';
// import 'package:thusmai_appointmrent/tabs/hometab.dart';
// import 'package:thusmai_appointmrent/tabs/messsagetab.dart';
// import 'package:thusmai_appointmrent/pages/profile/profile.dart';
// import 'package:thusmai_appointmrent/widgets/additionnalwidget.dart';
// import '../controller/connectivitycontroller.dart';
// import '../controller/login_register_otp_api.dart';
// import '../services/firebase_notification.dart';
// import '../tabs/meditationTab.dart';
// import '../tabs/paymentTab.dart';
//
// class CustomBottomNavBar extends StatefulWidget {
//   const CustomBottomNavBar({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
// }
//
// class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
//   @override
//   void initState() {
//     super.initState();
//     FirebaseApi().initNotifications();
//     Provider.of<AppLogin>(context, listen: false).importantFlags();
//   }
//
//   bool _videoEnabled = true;
//   bool _homeEnabled = true;
//   bool _meditationEnabled = true;
//   bool _paymentsEnabled = true;
//
//   final List<Widget> _pages = [
//     VideosPageOne(),
//     HomeTab(),
//     MeditationTab(),
//     PaymentTab(),
//   ];
//
//   void onPopInvoked(BuildContext context, bool didPop) {
//     final indexProvider = Provider.of<AppLogin>(context, listen: false);
//     if (didPop) {
//       return;
//     } else if (indexProvider.currentIndex!= 1) {
//       indexProvider.currentIndex = 1;
//     } else if (indexProvider.currentIndex == 1) {
//       showExitConfirmationDialog(context);
//     } else {
//       Navigator.pop(context);
//     }
//   }
//
//   void showExitConfirmationDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Exit App"),
//           content: Text("Are you sure you want to exit the app?"),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//                 SystemNavigator.pop(); // Exit the app
//               },
//               child: Text("Exit"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var flagModel = Provider.of<AppLogin>(context).flagModel;
//     var connect = Provider.of<ConnectivityProvider>(context);
//     var indexProvider = Provider.of<AppLogin>(context);
//
//     return PopScope( // Corrected from PopScope to WillPopScope
//       canPop: true,
//       onPopInvoked: (didPop) => onPopInvoked(context, didPop),
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: darkShade,
//           leading: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Image(
//               image: AssetImage(logo),
//             ),
//           ),
//           actions: [
//             IconButton(
//               onPressed: () {
//                 if (flagModel.maintenancePaymentStatus == true) {
//                   slidePageRoute(context, MessageTab());
//                 } else {
//                   Provider.of<AppLogin>(context, listen: false).currentIndex = 3;
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       backgroundColor: Colors.red,
//                       content: Text(enableMessage),
//                       duration: Duration(seconds: 2),
//                     ),
//                   );
//                 }
//               },
//               icon: Icon(
//                 Icons.message_outlined,
//                 color: flagModel.maintenancePaymentStatus == true? shadeSix : Colors.grey,
//               ),
//             ),
//
//             IconButton(
//               onPressed: () {
//                 Provider.of<AppLogin>(context, listen: false).getUserByID();
//                 slidePageRoute(context, Profile());
//               },
//               icon: Icon(
//                 Icons.account_circle,
//                 color: shadeSix,
//               ),
//             ),
//           ],
//         ),
//         body: _pages[indexProvider.currentIndex],
//         bottomNavigationBar: Container(
//           height: 80,
//           color: darkShade, // Background color of the bottom navigation bar
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               buildNavBarItem(
//                   currentIndex: indexProvider.currentIndex,
//                   icon: indexProvider.currentIndex!= 0? Icons.videocam_outlined : Icons.videocam,
//                   label: videos,
//                   index: 0,
//                   isEnabled: _videoEnabled),
//               buildNavBarItem(
//                   currentIndex: indexProvider.currentIndex,
//                   icon: indexProvider.currentIndex!= 1? Icons.home_outlined : Icons.home_rounded,
//                   label: home,
//                   index: 1,
//                   isEnabled: _homeEnabled),
//               buildNavBarItem(
//                   currentIndex: indexProvider.currentIndex,
//                   icon: Icons.self_improvement,
//                   label: meditation,
//                   index: 2,
//                   isEnabled: _meditationEnabled),
//               buildNavBarItem(
//                   currentIndex: indexProvider.currentIndex,
//                   icon: indexProvider.currentIndex!= 3? Icons.payments_outlined : Icons.payments_rounded,
//                   label: payment,
//                   index: 3,
//                   isEnabled: _paymentsEnabled),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildNavBarItem({
//     required int currentIndex,
//     required IconData icon,
//     required String label,
//     required int index,
//     required bool isEnabled,
//   }) {
//     return GestureDetector(
//       onTap: isEnabled
//           ? () {
//         Provider.of<AppLogin>(context, listen: false).currentIndex = index;
//       }
//           : () {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(enable),
//             duration: Duration(seconds: 2),
//           ),
//         );
//       },
//       child: Container(
//         width: MediaQuery.of(context).size.width / 4, // Divide by number of items
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 64.w,
//               height: 32.h,
//               decoration: BoxDecoration(
//                 color: currentIndex == index? shadeEleven : darkShade,
//                 borderRadius: BorderRadius.circular(20.sp),
//               ),
//               child: Icon(
//                 icon,
//                 color: isEnabled
//                     ? currentIndex == index
//                     ? shadeSix
//                     : shadeFive
//                     : Colors.grey, // Icon color
//               ),
//             ),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 12.sp,
//                 color: isEnabled
//                     ? currentIndex == index
//                     ? shadeTwo
//                     : shadeFive
//                     : Colors.grey, // Text color
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
