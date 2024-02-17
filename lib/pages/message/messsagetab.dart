import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/main.dart';
import '../../constant/appointment_constant.dart';
import '../../controller/appointment_controller.dart';
import 'message_guru.dart';



class MessageTab extends StatefulWidget {
  const MessageTab({Key? key}) : super(key: key);

  @override
  State<MessageTab> createState() => _MessageTabState();
}



class _MessageTabState extends State<MessageTab> {


  TextEditingController _phoneRegistered = TextEditingController(text: phone);

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
    var pro = Provider.of<AppointmentProvider>(context);
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
                          style: GoogleFonts.schoolbell(
                              fontSize: 24.sp, color: Color.fromRGBO(67, 44, 0, .3)),
                        )),
                  ),
                ),
                ChatScreen(),
                  Container(
                    color: pageBackground,
                    child: Center(
                        child: Text(
                          pageUnderWork,
                          style: GoogleFonts.schoolbell(
                              fontSize: 24.sp, color: Color.fromRGBO(67, 44, 0, .3)),
                        )),
                  ),
              ],
              onChange: (index) {
                pro.selectedIndex = index;
                print(index);
              },
            ),
          ),
        ),
      ),
    );
  }

}
