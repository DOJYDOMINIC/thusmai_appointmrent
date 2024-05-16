import 'package:flutter/material.dart';
import '../../constant/constant.dart';
import '../../widgets/additionnalwidget.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //       onPressed: () {
      //         Navigator.pop(context);
      //       },
      //       icon: Icon(
      //         Icons.arrow_back,
      //         color: shadeOne,
      //       )),
      //   backgroundColor: darkShade,
      //   title: Text(
      //     "Notifications",
      //     style: TextStyle(color: shadeOne),
      //   ),
      // ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          final Uri rewardUrl = Uri.parse("https://thasmai.tstsvc.in");
          return  transactionWidget(Icons.videocam_outlined,"28 Jan 2024","Notification","Lorem ipsum dolor sit amet consectetur.","2500",rewardUrl,(){});
        },),
    );
  }
}

