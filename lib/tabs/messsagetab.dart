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
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<AppointmentController>(context);
    return DefaultTabController(
      initialIndex: 0,
       length: 3,
      child: Scaffold(
        backgroundColor:shadeOne,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: shadeOne,
              )),
          backgroundColor: darkShade,
          title: Text(
            "Message",
            style: TextStyle(color: shadeOne),
          ),
          bottom: TabBar (
            indicatorColor: goldShade,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 2,
            unselectedLabelColor: Colors.grey,
            labelColor: shadeOne,
            tabs: [
          Tab(
            child: Text(
              "My Notes",
            ),
          ),
        Tab(
          child: Text(
            "Guruji",
          ),
        ),
        Tab(
          child: Text(
            "General",
          ),
        ),
        ],),
          // centerTitle: true,
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              PrivateMessage(),
              GuruMessage(),
              GeneralMessage(),
            ],
          ),
        ),
      ),
    );
  }

}
