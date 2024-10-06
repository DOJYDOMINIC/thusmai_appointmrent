import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import '../../constant/constant.dart';
import '../../controller/login_register_otp_api.dart';
import '../../controller/payment_controller.dart';

class PaymentToTrust extends StatefulWidget {
  const PaymentToTrust({super.key});

  @override
  _PaymentToTrustState createState() => _PaymentToTrustState();
}

class _PaymentToTrustState extends State<PaymentToTrust> {
  late Razorpay _razorpay;
  TextEditingController donationController = TextEditingController();

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
    var payment = Provider.of<PaymentController>(context, listen: false);
    var pro = Provider.of<AppLogin>(context, listen: false);
    var amount = double.parse(donationController.text);
    donationController.clear();
    setState(() {});
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

    payment.paymentSuccess(context, "donation-paymentVerification", data);

    // Handle payment success
    // print("Payment Successful: $response");
  }

  void _handlePaymentError(BuildContext context, PaymentFailureResponse response) {
    // Show SnackBar for payment error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Error: ${response.message}'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _handleExternalWallet(BuildContext context, ExternalWalletResponse response) {
    // Show SnackBar for external wallet selection
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('External Wallet Selected: ${response.walletName}'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // void _openCheckout() {
  //   int amount = donationController.text.isNotEmpty
  //       ? int.parse(donationController.text)
  //       : 0; // Default amount
  //
  //   var options = {
  //     'key': 'rzp_test_1DP5mmOlF5G5ag', // Replace with your Razorpay key
  //     'amount': amount * 100, // Amount is in paise
  //     'name': 'Donation to Trust',
  //     'description': 'Donation Payment',
  //     'prefill': {'contact': '1234567890', 'email': 'test@razorpay.com'},
  //     // 'method': {
  //     //   'upi': true,
  //     // },
  //     'external': {
  //       'wallets': ['paytm']
  //     }
  //   };
  //
  //   try {
  //     _razorpay.open(options);
  //   } catch (e) {
  //     debugPrint('Error: $e');
  //   }
  // }

  Future<void> _createOrderAndOpenCheckout() async {
    var userData =  Provider.of<AppLogin>(context,listen: false).userData;
    Provider.of<AppLogin>(context,listen: false).disableButton();
    try {
      var amount = double.parse(donationController.text);
      double total = amount * 100;
      final url = Uri.parse('$paymentBaseUrl/donation-checkout');
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'amount': total,
        }),
      );

      if (response.statusCode == 200) {
        final orderData = jsonDecode(response.body);
        final String orderId = orderData['order']["id"];
        var options = {
          'key': 'rzp_live_pUPUZItNLjg8oO',
          'amount': total, // Amount is in paise
          'name': 'Meditation Payment',
          'order_id': orderId,
          'description': 'Meditation second payment',
          'prefill': {
            'contact':userData?.phone,
            'email': userData?.email,
          },
          'external': {
            'wallets': ['paytm']
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
            content: Text('Failed to create order'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to create order'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
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
            padding: const EdgeInsets.all(8.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                    "Lorem ipsum dolor sit amet consectetur. Mauris condimentum vulputate rhoncus nisl iaculis aliquam."),
                SizedBox(height: 20),
                Column(
                  children: [
                    SizedBox(
                      height: 56,
                      child: TextFormField(
                        onChanged: (val) {
                          setState(() {});
                        },
                        controller: donationController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(16),
                          fillColor: goldShade.withOpacity(.3),
                          filled: true,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: SvgPicture.asset(
                              "assets/svgImage/approval_delegation.svg",
                              color: darkShade,
                            ),
                          ),
                          hintText: "Donations",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: darkShade.withOpacity(.5)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: darkShade.withOpacity(.5)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Total Amount    ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          ": ${donationController.text}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed:Provider.of<AppLogin>(context).isButtonDisabled ? null :  _createOrderAndOpenCheckout,
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.black,
                      backgroundColor:Provider.of<AppLogin>(context).isButtonDisabled ? null : goldShade,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Pay ${donationController.text}",
                          style: TextStyle(color: darkShade),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
