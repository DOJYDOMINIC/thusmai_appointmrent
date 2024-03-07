import 'package:connectivity/connectivity.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constant/constant.dart';
import '../controller/appointmentontroller_api.dart';
import 'appointment/list_appointment.dart';



class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {

  @override
  void initState() {
    super.initState();
    // Listen for connectivity changes
    // Connectivity().onConnectivityChanged.listen((result) {
    //   if (result == ConnectivityResult.none) {
    //     // No internet connection
    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       backgroundColor: Colors.red,
    //       content: Text('No internet connection'),
    //     ));
    //   } else {
    //     // Internet connection established
    //     ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //       backgroundColor: Colors.green,
    //       content: Text('Connected to the internet'),
    //     ));
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<AppointmentController>(context);
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          body: ContainedTabBarView(
            tabBarProperties: TabBarProperties(
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: buttonColor,
              indicatorWeight: 2,
              background: Container(
                color: appbar,
              ),
            ),
            tabs: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.dashboard_outlined,
                    color: pro.selectedIndex == 0 ? navIcon : tabInactive,
                  ),
                  Text(
                    overview,
                    style: TextStyle(
                      color: pro.selectedIndex == 0 ? navIcon : tabInactive,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_available,
                    color: pro.selectedIndex == 1 ? navIcon : tabInactive,
                  ),
                  Text(
                    appointment,
                    style: TextStyle(
                      color: pro.selectedIndex == 1 ? navIcon : tabInactive,
                    ),
                  ),
                ],
              ),
            ],
            views: [
              GestureDetector(
                onTap: () {
                  if (!FocusScope.of(context).hasPrimaryFocus) {
                    FocusScope.of(context).unfocus();
                  }
                },
                child: Container(
                  color: pageBackground,
                  child: Center(child: Text(
                    pageUnderWork,
                    style: GoogleFonts.schoolbell(
                        fontSize: 24.sp,
                        color: Color.fromRGBO(67, 44, 0, .3)),
                  ),),
                ),
              ),
              AppointmentListPage(),
            ],
            onChange: (index) {
              pro.selectedIndex = index;
              print(index);
            },
          ),
        ),
      ),
    );
  }
}
