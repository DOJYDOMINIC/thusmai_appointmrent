import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constant/constant.dart';
import '../controller/appointmentontroller.dart';
import '../pages/meditation/meditationlog.dart';
import '../pages/meditation/meditationsetup.dart';



class MeditationTab extends StatefulWidget {
  const MeditationTab({super.key});

  @override
  State<MeditationTab> createState() => _MeditationTabState();
}

class _MeditationTabState extends State<MeditationTab> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<AppointmentController>(context);
    return Scaffold(
      backgroundColor: shadeOne,
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
                    Icons.timer,
                    color: pro.selectedIndex == 0 ? shadeSix : shadeTwo,
                  ),
                  Text(
                    "Meditate",
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
                    "Meditation Log",
                    style: TextStyle(
                      color: pro.selectedIndex == 1 ? shadeSix : shadeTwo,
                    ),
                  ),
                ],
              ),
            ],
            views: [
              Meditationcycle(),
              MeditationLog(),
              // SelectedDatesScreen()
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
