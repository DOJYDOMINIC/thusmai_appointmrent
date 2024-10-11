import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:thusmai_appointmrent/pages/profile/profile.dart';
import '../../constant/constant.dart';
import '../../controller/login_register_otp_api.dart';
import '../../controller/profileController.dart';

class ReferPage extends StatefulWidget {
  const ReferPage({super.key});

  @override
  State<ReferPage> createState() => _ReferPageState();
}

class _ReferPageState extends State<ReferPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProfileController>(context, listen: false).getBankDetails();
  }

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<AppLogin>(context);
    return Scaffold(
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
          "Refer",
          style: TextStyle(color: shadeOne),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.rotate(
              angle: 12, // Specify the angle in radians
              child: SvgPicture.asset(
                megaphone,
                color: darkShade,
                width: 80.w,
                height: 80.h,
              ),
            ),
            Text(
              "✨ Bring a Friend, Elevate Together! ✨",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            ),
            SizedBox(
              height: 16.h,
            ),
            Text(
                "Refer a friend to our spiritual family, and watch your blessings multiply as you both embark on a transformative journey filled with joy and enlightenment!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16)),
            SizedBox(
              height: 40.h,
            ),
            SizedBox(
              height: 56.h,
              child: ElevatedButton(
                onPressed: () {
                  Share.share('$coreUrl/?id=${pro.userData?.uId}',
                      subject: 'Thasmai');
                },
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.black,
                  backgroundColor: goldShade,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Share",
                      style: TextStyle(color: darkShade),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
