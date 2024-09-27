import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../constant/constant.dart';
import '../controller/appointmentontroller.dart';
import '../pages/message/general_message.dart';
import '../pages/message/message_guru.dart';
import '../pages/message/privatemessage.dart';

class MessageTab extends StatefulWidget {

  const MessageTab({Key? key}) : super(key: key);

  @override
  State<MessageTab> createState() => _MessageTabState();
}

class _MessageTabState extends State<MessageTab> {
  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<AppointmentController>(context);
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        backgroundColor: shadeOne,
        body: SafeArea(
          child: Column(
            children: [
              // TabBar with no AppBar
              PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: Container(
                  color: darkShade, // Background color for the tab bar
                  child: TabBar(
                    indicatorColor: goldShade,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorWeight: 2,
                    unselectedLabelColor: Colors.grey,
                    labelColor: shadeOne,
                    tabs: const [
                      Tab(
                        child: Text("My Notes"),
                      ),
                      Tab(
                        child: Text("Guruji"),
                      ),
                      Tab(
                        child: Text("Global"),
                      ),
                    ],
                  ),
                ),
              ),
              // TabBarView
              Expanded(
                child: TabBarView(
                  children: [
                    PrivateMessage(),
                    GuruMessage(),
                    GeneralMessage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
