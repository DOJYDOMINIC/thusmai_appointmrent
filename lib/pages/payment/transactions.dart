import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    _timer = Timer(Duration(seconds: 10), () {
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
      body: data.transactions?.length != null
          ? ListView.builder(
              itemCount: data.transactions!.length,
              itemBuilder: (context, index) {
                String? capitalizedType = data.transactions?[index].type;
                if(data.transactions?[index].type != null){
                  capitalizedType = (capitalizedType![0].toUpperCase() + capitalizedType.substring(1));
                }
                return transactionWidget(
                    getIconBasedOnString(data.transactions![index].type.toString()) as IconData,
                    "${data.transactions![index].paymentDate}",
                    "$capitalizedType",
                    "${data.transactions![index].razorpayOrderId}",
                    "${data.transactions![index].amount}",
                    () {});
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