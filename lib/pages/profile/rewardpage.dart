import 'package:flutter/material.dart';
import 'package:thusmai_appointmrent/pages/profile/profile.dart';
import '../../constant/constant.dart';
import '../../widgets/additionnalwidget.dart';

class RewardPage extends StatelessWidget {
  const RewardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Profile(),));
            },
            icon: Icon(
              Icons.arrow_back,
              color: shadeOne,
            )),
        backgroundColor: darkShade,
        title: Text(
          "Reward",
          style: TextStyle(color: shadeOne),
        ),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          final Uri rewardUrl = Uri.parse("https://thasmai.tstsvc.in");
        return  rewardWidget(guruji,"Reward 01","Lorem ipsum dolor sit amet consectetur.","3 days",rewardUrl);
      },),
    );
  }
}

