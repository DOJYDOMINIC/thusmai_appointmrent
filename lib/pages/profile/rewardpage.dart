import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/pages/profile/profile.dart';
import '../../constant/constant.dart';
import '../../controller/profileController.dart';
import '../../widgets/additionnalwidget.dart';

class RewardPage extends StatefulWidget {
  const RewardPage({super.key});

  @override
  State<RewardPage> createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {

  @override
  void initState() {

    super.initState();
 Provider.of<ProfileController>(context,listen: false).rewardList();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  Profile(),));
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
