import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constant/constant.dart';
import '../controller/appointmentontroller.dart';
import '../pages/appointment/list_appointment.dart';
import '../pages/overview/overview.dart';



class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {

  @override
  void initState() {
    super.initState();
    // Provider.of<AppLogin>(context,listen: false).tokenSave();
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
              indicatorColor: goldShade,
              indicatorWeight: 2,
              background: Container(
                color: darkShade,
              ),
            ),
            tabs: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.dashboard_outlined,
                    color: pro.selectedIndex == 0 ? shadeSix : shadeTwo,
                  ),
                  Text(
                    overview,
                    style: TextStyle(
                      color: pro.selectedIndex == 0 ? shadeSix : shadeTwo,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_available,
                    color: pro.selectedIndex == 1 ? shadeSix : shadeTwo,
                  ),
                  Text(
                    appointment,
                    style: TextStyle(
                      color: pro.selectedIndex == 1 ? shadeSix : shadeTwo,
                    ),
                  ),
                ],
              ),
            ],
            views: [
              Overview(),
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