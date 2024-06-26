import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';
import 'package:thusmai_appointmrent/pages/videos/videospageone.dart';
import 'package:thusmai_appointmrent/tabs/hometab.dart';
import 'package:thusmai_appointmrent/tabs/messsagetab.dart';
import 'package:thusmai_appointmrent/pages/profile/profile.dart';
import 'package:thusmai_appointmrent/widgets/additionnalwidget.dart';
import '../controller/connectivitycontroller.dart';
import '../controller/login_register_otp_api.dart';
import '../services/firebase_notification.dart';
import '../tabs/meditationTab.dart';
import '../tabs/paymentTab.dart';

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
    // runTest();
    FirebaseApi().initNotifications();
    // Provider.of<ConnectivityProvider>(context, listen: false).status;
    Provider.of<AppLogin>(context, listen: false).importantFlags();
  }

  bool _videoEnabled = true;
  bool _homeEnabled = true;
  bool _meditationEnabled = true;
  bool _paymentsEnabled = true;

  final List<Widget> _pages = [
    VideosPageOne(),
    HomeTab(),
    MeditationTab(),
    PaymentTab(),
  ];

  void onPopInvoked(BuildContext context, bool didPop) {
    final indexProvider = Provider.of<AppLogin>(context, listen: false);
    if (didPop) {
      return;
    } else if (indexProvider.currentIndex != 1) {
      indexProvider.currentIndex = 1;
    } else if (indexProvider.currentIndex == 1) {
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
    var connect = Provider.of<ConnectivityProvider>(context);
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
            IconButton(
              onPressed: () {
                if (flagModel.maintenancePaymentStatus == true) {
                  slidePageRoute(context, MessageTab());
                } else {
                  Provider.of<AppLogin>(context, listen: false).currentIndex = 3;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(enableMessage),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              icon: Icon(
                Icons.message_outlined,
                color: flagModel.maintenancePaymentStatus == true ? shadeSix : Colors.grey,
              ),
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
                  icon: indexProvider.currentIndex != 0 ? Icons.videocam_outlined : Icons.videocam,
                  label: videos,
                  index: 0,
                  isEnabled: _videoEnabled),
              buildNavBarItem(
                  currentIndex: indexProvider.currentIndex,
                  icon: indexProvider.currentIndex != 1 ? Icons.home_outlined : Icons.home_rounded,
                  label: home,
                  index: 1,
                  isEnabled: _homeEnabled),
              buildNavBarItem(
                  currentIndex: indexProvider.currentIndex,
                  icon: Icons.self_improvement,
                  label: meditation,
                  index: 2,
                  isEnabled: _meditationEnabled),
              buildNavBarItem(
                  currentIndex: indexProvider.currentIndex,
                  icon: indexProvider.currentIndex != 3 ? Icons.payments_outlined : Icons.payments_rounded,
                  label: payment,
                  index: 3,
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
        Provider.of<AppLogin>(context, listen: false).currentIndex = index;
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
        width: MediaQuery.of(context).size.width / 4, // Divide by number of items
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
