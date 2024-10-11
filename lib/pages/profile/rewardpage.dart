import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    Provider.of<ProfileController>(context, listen: false).rewardList();
  }

  @override
  Widget build(BuildContext context) {
    var rewardListData = Provider.of<ProfileController>(context).rewardListData;
    // print(rewardListData![0].distributionTime.toString());
    return Scaffold(
      backgroundColor: shadeOne,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profile(),
                  ));
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
      body: rewardListData?.length != null
          ? ListView.builder(
              itemCount: rewardListData?.length,
              itemBuilder: (context, index) {
                DateTime dateTime = DateTime.parse(
                    rewardListData?[index].distributionTime.toString() ?? "");
                String formattedDate =
                    DateFormat('yyyy/MM/dd').format(dateTime);
                String formattedTime =
                    DateFormat('hh:mm:ss a').format(dateTime);
                return rewardWidget(
                    formattedTime,
                    "Rs : ${rewardListData?[index].reward.toString()}",
                    formattedDate);
              },
            )
          : Center(
              child: Text(
                'No data found',
                style: TextStyle(
                  fontSize: 18, // Adjust the font size as needed
                  fontWeight: FontWeight.bold, // Optionally make it bold
                  color: Colors.grey, // Adjust the color as needed
                ),
              ),
            ),
    );
  }
}
