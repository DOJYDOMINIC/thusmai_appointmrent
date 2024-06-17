import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/pages/payment/paymenttotrust.dart';

import '../../constant/constant.dart';
import '../../controller/connectivitycontroller.dart';
import '../../controller/login_register_otp_api.dart';
import '../../controller/overviewController.dart';
import '../../controller/payment_controller.dart';
import '../../controller/zoommeeting_controller.dart';
import '../refreshpage.dart';
import 'meditationpayment.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<AppLogin>(context, listen: false).validateSession(context);
    Provider.of<PaymentController>(context,listen: false).transactionData();
  }

  @override
  Widget build(BuildContext context) {
    var connect = Provider.of<ConnectivityProvider>(context);
    var transactionSummary = Provider.of<PaymentController>(context).transactionSummary;
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        body: connect.status == ConnectivityStatus.Offline
            ?RefreshPage(
          onTap: () {
            Provider.of<AppLogin>(context, listen: false).getUserByID();
            Provider.of<AppLogin>(context, listen: false)
                .importantFlags();
            Provider.of<OverViewController>(context, listen: false)
                .eventList();
            Provider.of<ConnectivityProvider>(context, listen: false)
                .status;
            Provider.of<ZoomMeetingController>(context,listen: false).zoomClass();

          },):  SingleChildScrollView(
            child: SizedBox(
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
                                  Text(": ${transactionSummary.totalguru??0}"),
                                  Text(": ${transactionSummary.totaltrust??0}"),
                                  Text(
                                    ": ${transactionSummary.total??0}",
                                    style: TextStyle(
                                      fontSize: 16.0, // adjust the font size as needed
                                      fontWeight: FontWeight.w500, // adjust the font weight as needed
                                    ),
                                  ),
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
                                Text("${transactionSummary.totalTransactionCount??0}"),
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
