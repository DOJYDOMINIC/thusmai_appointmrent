
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';
import 'package:http/http.dart' as http;


class PaymentController extends ChangeNotifier {


  Future<void> paymentStatus(BuildContext context, int? data,) async {
    debugPrint( data.toString());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    final response = await http.post(Uri.parse("$adminBaseUrl/processPayment"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (cookies != null) 'Cookie': cookies,
        },
        body: jsonEncode({"uid" : data}));
    // var decode = jsonDecode(response.body);
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

}