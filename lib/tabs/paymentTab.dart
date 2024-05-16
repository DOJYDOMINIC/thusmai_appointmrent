import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../constant/constant.dart';
import '../../controller/appointmentontroller.dart';
import '../pages/payment/payments.dart';
import '../pages/payment/transactions.dart';





class PaymentTab extends StatefulWidget {
  const PaymentTab({super.key});

  @override
  State<PaymentTab> createState() => _PaymentTabState();
}

class _PaymentTabState extends State<PaymentTab> {

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
          body: ContainedTabBarView(
            tabBarProperties: TabBarProperties(
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: goldShade,
              indicatorWeight: 2,
              background: Container(
                color: darkShade,
              ),
            ),
            tabs: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              SvgPicture.asset( "assets/svgImage/approval_delegation.svg", color: pro.selectedIndex == 0 ? shadeSix : shadeTwo,),
                  Text(
                    "Payments",
                    style: TextStyle(
                      color: pro.selectedIndex == 0 ? shadeSix : shadeTwo,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sync_alt,
                    color: pro.selectedIndex == 1 ? shadeSix : shadeTwo,
                  ),
                  Text(
                    "Transactions",
                    style: TextStyle(
                      color: pro.selectedIndex == 1 ? shadeSix : shadeTwo,
                    ),
                  ),
                ],
              ),
            ],
            views: [
              PaymentPage(),
              TransactionsPage(),
            ],
            onChange: (index) {
              pro.selectedIndex = index;
              print(index);
            },
          ),
        ),
      ),
    );
  }
}
