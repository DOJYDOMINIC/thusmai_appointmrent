import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';
import '../../controller/login_register_otp_api.dart';
import '../../controller/payment_controller.dart';
import '../../widgets/additionnalwidget.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key})
      : super(key: key); // Corrected super key declaration

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  bool _isLoading = true;
  late Timer _timer; // Added Timer variable

  @override
  void initState() {
    super.initState();
    Provider.of<AppLogin>(context, listen: false).validateSession(context);
    _timer = Timer(const Duration(seconds: 5), () {
      setState(() {
        _isLoading = false;
      });
    });
    Provider.of<PaymentController>(context, listen: false).transactionList();
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<PaymentController>(context).transactionLists;
    return Scaffold(
      backgroundColor: shadeOne,
      body: data.transactions?.length != null
          ? ListView.builder(
              itemCount: data.transactions!.length,
              itemBuilder: (context, index) {
                DateTime paymentDate = DateTime.parse(data.transactions![index].paymentDate.toString());
                String formattedDate = DateFormat('dd/MM/yyyy').format(paymentDate);
                String? capitalizedType = data.transactions?[index].type;
                if(data.transactions?[index].type != null){
                  capitalizedType = (capitalizedType![0].toUpperCase() + capitalizedType.substring(1));
                }
                return transactionWidget(
                    getIconBasedOnString(data.transactions![index].type.toString()) as IconData,
                    "${formattedDate}",
                    "$capitalizedType",
                    "${data.transactions![index].razorpayOrderId}",
                    "${data.transactions![index].amount}",
                    () {
                      Clipboard.setData(ClipboardData(text:"${data.transactions![index].razorpayOrderId}"));
                    });
              },
            )
          : _isLoading
              ? Center(child: CircularProgressIndicator())
              : Center(
                  child: Text(
                    'No Data Found',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
    );
  }
}

Object getIconBasedOnString(String type) {
  switch (type) {
    case 'dekshina':
      return Icons.volunteer_activism_outlined;
    case 'meditation':
      return Icons.self_improvement;
    case 'maintenance':
      return Icons.videocam_outlined;
    default:
      return Icons.verified_outlined; // Default case if no match is found
  }
}