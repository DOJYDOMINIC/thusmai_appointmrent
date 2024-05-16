import 'package:flutter/material.dart';
import 'package:thusmai_appointmrent/pages/payment/paymenttotrust.dart';

import '../../constant/constant.dart';
import 'meditationpayment.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        goldShade.withOpacity(.8), // Lighter color
                        goldShade.withOpacity(.5), // Lighter color
                        goldShade.withOpacity(.3), // Lighter color
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 150,
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Amount to Guru "),
                                Text("Amount to Trust "),
                                Text("Total "),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(": 5000"),
                                Text(": 5000"),
                                Text(": 10k"),
                              ],
                            ),
                          ],
                        ),
                      ),
          
                      Container(
                        height: 110,
                        width: 2,
                        color: ringColor,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text("Transactions"),
                              Text("3"),
                            ],
                          ),
                          Text(""),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                SizedBox(
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0), // Adjust the radius as needed
                      topRight: Radius.circular(20.0), // Adjust the radius as needed
                    ),
                    child: AppBar(
                      backgroundColor: goldShade.withOpacity(.2),
                      bottom: TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorColor: darkShade,
                        indicatorWeight: 1,
                        tabs: [
                          Tab(
                            child:
                            Text("Meditation",style: TextStyle(color: darkShade),),
                          ),
                          Tab(
                            child:
                          Text("To Trust",style: TextStyle(color: darkShade),),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          
                // create widgets for each tab bar here
                Expanded(
                  child: TabBarView(
                    children: [
                      // first tab bar view widget
                      // second tab bar viiew widget
                      MeditationPayment(),
                      PaymentToTrust(),
                      // PaymentScreen()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
