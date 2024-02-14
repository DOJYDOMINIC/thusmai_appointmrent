import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constant/constant.dart';
import '../controller/appointment_controller.dart';
import 'appointment_list.dart';

class HomeTab extends StatefulWidget {

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<AppointmentProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: textBoxBorder,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image(
            image: AssetImage(logo),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.circle_notifications_outlined,
              color: textFieldOutline,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.account_circle,
              color: textFieldOutline,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: ContainedTabBarView(
            tabBarProperties: TabBarProperties(
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: buttonColor,
              indicatorWeight: 2,
              background: Container(
                color: textBoxBorder,
              ),
            ),
            tabs: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.dashboard_outlined,
                    color: pro.selectedIndex == 0 ? pageBackground : Colors.grey,
                  ),
                  Text(
                    overview,
                    style: TextStyle(
                      color: pro.selectedIndex == 0 ? pageBackground : Colors.grey,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_available,
                    color: pro.selectedIndex == 1 ? pageBackground : Colors.grey,
                  ),
                  Text(
                    appointment,
                    style: TextStyle(
                      color: pro.selectedIndex == 1 ? pageBackground : Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
            views: [
              Container(
                color: pageBackground,
                child: Center(child: Text("Page Under Progress !",style: GoogleFonts.schoolbell(fontSize: 24.sp,color: Color.fromRGBO(67, 44, 0, .3)),)),
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

  @override
  void initState() {
    super.initState();
    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        // No internet connection
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('No internet connection'),
        ));
      } else {
        // Internet connection established
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text('Connected to the internet'),
        ));
      }
    });
  }
}
