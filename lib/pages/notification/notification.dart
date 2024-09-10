import 'package:flutter/material.dart';
import '../../constant/constant.dart';
import '../../widgets/additionnalwidget.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Notifications",
          style: TextStyle(color: shadeOne),
        ),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          // final Uri rewardUrl = Uri.parse("$registerUrl");
          return  rewardWidget(guruji,"Notification","Lorem ipsum dolor sit amet consectetur.");
        },),
    );
  }
}

