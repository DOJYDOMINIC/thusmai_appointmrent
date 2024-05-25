
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';
import 'package:http/http.dart' as http;

import '../models/transaction_list.dart';
import '../models/transactionsummary.dart';
import 'login_register_otp_api.dart';


class PaymentController extends ChangeNotifier {


  Future<void> processPayment(BuildContext context) async {
    var pro = Provider.of<AppLogin>(context,listen: false);


    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    final response = await http.post(Uri.parse("$adminBaseUrl/processPayment"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (cookies != null) 'Cookie': cookies,
        },
        body: jsonEncode({"uid" : pro.userData?.uId}));
    try {
      if (response.statusCode == 200) {
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
          // SnackBar(
          //   backgroundColor: Colors.red,
          //   // content: Text(decode["message"]),
          //   duration: Duration(seconds: 1),
          // ),
        // );
      }
    } catch (e) {
      print("meditationData : $e");
    }
    notifyListeners();
  }

  TransactionSummary _transactionSummary = TransactionSummary();
  TransactionSummary get transactionSummary => _transactionSummary;

  Future<void> transactionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");

    final response = await http.get(
      Uri.parse("$baseUrl/transaction_summary"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (cookies != null) 'Cookie': cookies,
      },
    );

    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _transactionSummary = TransactionSummary.fromJson(data);
        print(transactionSummary.totalguru.toString());
      } else {
        print("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error loading transaction data: $e");
    }
    notifyListeners();
  }

  TransactionList _transactionList = TransactionList();
  TransactionList get transactionLists => _transactionList;

  Future<void> transactionList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");

    final response = await http.get(
      Uri.parse("$baseUrl/transaction_list"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (cookies != null) 'Cookie': cookies,
      },
    );

    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _transactionList = TransactionList.fromJson(data);
        print("Total transactions: ${_transactionList.transactions?.length}");
      } else {
        print("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error loading transaction data: $e");
    }
    notifyListeners();
  }






  Future<void> paymentSuccess( BuildContext context,String url, Map<String,dynamic> paymentData,) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");

    try {
      var response = await http.post(
        Uri.parse("$paymentBaseUrl/$url"),
        headers: {
          'Content-Type': 'application/json',
          if (cookies != null) 'Cookie': cookies,
        },
        body: jsonEncode(paymentData),
      );
      if (response.statusCode == 200) {
        if(url == "meditation-paymentVerification"  && paymentData["amount"] ==2500){
          Provider.of<AppLogin>(context,listen: false).importantFlags();
          processPayment(context);
        }
     ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
      backgroundColor: Colors.green,
      content: Text("Payment Completed"),
      duration: Duration(seconds: 1),
    ),
    );
      } else {
        print('Failed to send time: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error to send time:: $e');
    }
  }
}
