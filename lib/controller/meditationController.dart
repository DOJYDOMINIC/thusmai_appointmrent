

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constant/constant.dart';
class MeditationController extends ChangeNotifier{

  Future<void> meditationTime(String start,String end) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    print(cookies);
    try {
      var response = await http.post(
        Uri.parse("$baseUrl/meditation"),
        headers: {
          'Content-Type': 'application/json',
          if (cookies != null) 'Cookie': cookies,
        },
        body: jsonEncode({
          "startdatetime":start,
          "stopdatetime":end
        }),
      );
      if (response.statusCode == 200) {
       print("sucess");
      } else {
        print('Failed to send time: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error to send time:: $e');
    }
    notifyListeners();
  }
}