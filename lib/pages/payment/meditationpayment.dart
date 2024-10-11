import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/constant.dart';
import 'package:http/http.dart' as http;
import '../../controller/login_register_otp_api.dart';
import '../../controller/payment_controller.dart';

class MeditationPayment extends StatefulWidget {
  const MeditationPayment({super.key});

  @override
  State<MeditationPayment> createState() => _MeditationPaymentState();
}

class _MeditationPaymentState extends State<MeditationPayment> {
  @override
  void initState() {
    super.initState();
    Provider.of<PaymentController>(context, listen: false)
        .financialConfiguration();
    Provider.of<AppLogin>(context, listen: false).importantFlags();
  }

  TextEditingController dakshinaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var flagModel = Provider.of<AppLogin>(context).flagModel;
    var finData = Provider.of<PaymentController>(context).financialConfig;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.centerRight,
            colors: [
              goldShade.withOpacity(.2),
              goldShade.withOpacity(.3),
              goldShade.withOpacity(.5),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8,
                ),
                if (flagModel.maintenancePaymentStatus == false)
                  MeditationPaymentWidget(
                    url: "maintenance-checkout",
                    icon: Icons.videocam,
                    amount: "${finData[3].value.toString()}",
                    dueDate: "Funds to enable Messages \nand Classes",
                    paymentType: 'Platform Maintenance',
                    noteIcon: "assets/svgImage/brightness_alert.svg",
                  ),
                if (flagModel.meditationFeePaymentStatus != false)
                  SizedBox(
                    height: 8,
                  ),
                if (flagModel.meditationFeePaymentStatus == false)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: MeditationPaymentWidget(
                      icon: Icons.self_improvement,
                      url: "meditation-checkout",
                      amount: "${finData[2].value.toString()}",
                      dueDate: "Fund to enable Meditation",
                      paymentType: 'Meditation payment',
                      noteIcon: 'assets/svgImage/brightness_alert.svg',
                    ),
                  ),
                // if(flagModel.meditationFeePaymentStatus == false)
                MeditationPaymentWidget(
                  icon: Icons.volunteer_activism,
                  url: "dekshina-checkout",
                  amount: "",
                  dueDate: "Sincerely appreciate your \nkindness.",
                  paymentType: 'Guru Dakshina',
                  noteIcon: "assets/svgImage/person_play.svg",
                  controller: dakshinaController,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MeditationPaymentWidget extends StatefulWidget {
  const MeditationPaymentWidget(
      {super.key,
      required this.icon,
      required this.amount,
      required this.dueDate,
      this.onPressed,
      required this.paymentType,
      required this.noteIcon,
      this.controller,
      required this.url});

  final IconData icon;
  final String noteIcon;
  final String url;
  final String paymentType;
  final String amount;
  final TextEditingController? controller;
  final String dueDate;
  final void Function()? onPressed;

  @override
  State<MeditationPaymentWidget> createState() =>
      _MeditationPaymentWidgetState();
}

class _MeditationPaymentWidgetState extends State<MeditationPaymentWidget> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    var pro = Provider.of<AppLogin>(context, listen: false);

    // Handle payment success
    print("Payment Successful: ${response.signature.toString()}");
    String signatur = response.signature.toString();

    String url;

    switch (widget.paymentType) {
      case 'Meditation payment':
        url = 'meditation-paymentVerification';
        break;
      case 'Platform Maintenance':
        url = 'maintenance-paymentVerification';
        break;
      case 'Guru Dakshina':
        url = 'dekshina-paymentVerification';
        break;
      default:
        url = '';
    }
    var payment = Provider.of<PaymentController>(context, listen: false);
    double amount = widget.amount.isEmpty && widget.controller != null
        ? double.parse(widget.controller!.text)
        : double.parse(widget.amount);
    widget.controller?.clear();
    print("lalal${response.signature.toString()}");
    DateTime day = DateTime.now();
    Map<String, dynamic> data = {
      "razorpay_order_id": response.orderId,
      "razorpay_payment_id": response.paymentId,
      "razorpay_signature": response.signature,
      "UId": pro.userData?.uId,
      "amount": amount,
      "payment_date": "$day",
      "payment_time": "${day.hour}:${day.minute}:${day.second}",
    };

    payment.paymentSuccess(context, url, data);
    print(url);
  }

  void _handlePaymentError(
      BuildContext context, PaymentFailureResponse response) {
    // Show SnackBar for payment error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Error: ${response.message}'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _handleExternalWallet(
      BuildContext context, ExternalWalletResponse response) {
    // Show SnackBar for external wallet selection
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('External Wallet Selected: ${response.walletName}'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _createOrderAndOpenCheckout() async {
    var userData = Provider.of<AppLogin>(context, listen: false).userData;

    Provider.of<AppLogin>(context, listen: false).disableButton();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    try {
      var amount = widget.amount.isEmpty && widget.controller != null
          ? double.parse(widget.controller!.text)
          : double.parse(widget.amount);
      var total = amount * 100;

      final url = Uri.parse('$paymentBaseUrl/${widget.url}');
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          if (cookies != null) 'Cookie': cookies,
        },
        body: jsonEncode(<String, dynamic>{
          'amount': total.toString(),
        }),
      );

      if (response.statusCode == 200) {
        final orderData = jsonDecode(response.body);
        final String orderId = orderData['order']["id"];
        var options = {
          'key': widget.paymentType == "Guru Dakshina"
              ? 'rzp_live_6HCUMMvTKrRJrA'
              : "rzp_live_pUPUZItNLjg8oO",
          'amount': total, // Amount is in paise
          'name': widget.paymentType,
          'order_id': orderId,
          'description': 'Payment for ${widget.paymentType}',
          'prefill': {
            'contact': userData?.phone,
            'email': userData?.email,
          },
          'external': {
            'wallets': ['paytm'],
          }
        };
        try {
          _razorpay.open(options);
        } catch (e) {
          print('Error: $e');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(failedCreateOrder),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(failedCreateOrder),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(widget.icon, size: 56.0),
                SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.paymentType),
                    if (widget.amount.isNotEmpty)
                      Row(
                        children: [
                          // SvgPicture.asset(
                          //     currencyRupee),
                          Text(" ${widget.amount}"),
                        ],
                      ),
                    if (widget.amount.isEmpty)
                      Row(
                        children: [
                          // SvgPicture.asset(
                          //     currencyRupee),
                          SizedBox(
                            height: 45.h,
                            width: 150.w,
                            child: TextFormField(
                              controller: widget.controller,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: dakshina,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(0.5)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(0.5)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(widget.noteIcon),
                      SizedBox(width: 8.0),
                      Text(widget.dueDate, style: TextStyle(fontSize: 12.0)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40.h,
                  width: 91.w,
                  child: ElevatedButton(
                    onPressed: Provider.of<AppLogin>(context).isButtonDisabled
                        ? null
                        : _createOrderAndOpenCheckout,
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.black,
                      backgroundColor:
                          Provider.of<AppLogin>(context).isButtonDisabled
                              ? null
                              : goldShade,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(pay, style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
