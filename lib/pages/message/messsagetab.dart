import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constant/constant.dart';
import '../../controller/appointmentontroller.dart';
import 'message_guru.dart';

class MessageTab extends StatefulWidget {

  const MessageTab({Key? key}) : super(key: key);

  @override
  State<MessageTab> createState() => _MessageTabState();
}

class _MessageTabState extends State<MessageTab> {


  int _currentindex = 0;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<AppointmentController>(context);
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          body: Container(
            child: ContainedTabBarView(
              tabBarProperties: TabBarProperties(
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: appbar,
                indicatorWeight: 2,
                background: Container(
                  color: pageBackground,
                ),
              ),
              tabs: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Private",
                      style: TextStyle(
                        color: pro.selectedIndex == 0 ? appbar : Colors.grey,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Guru",
                      style: TextStyle(
                        color: pro.selectedIndex == 1 ? appbar : Colors.grey,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Global",
                      style: TextStyle(
                        color: pro.selectedIndex == 2 ? appbar : Colors.grey,
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
                    child: Center(
                      child: Text(
                        pageUnderWork,
                        style:TextStyle(
                          fontSize: 24.sp,
                          color: Color.fromRGBO(67, 44, 0, .3),
                        ),
                      ),
                    ),
                  ),
                ),
                ChatScreenGuru(),
                Container(
                  color: pageBackground,
                  child: Center(
                    child: Text(
                      pageUnderWork,
                      style: TextStyle(
                        fontSize: 24.sp,
                        color: Color.fromRGBO(67, 44, 0, .3),
                      ),
                    ),
                  ),
                ),
              ],
              onChange: (index) {
               pro.selectedIndex = index;
              },
            ),
          ),
        ),
      ),
    );
  }

}
