

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';
import 'package:http/http.dart' as http;
class ZoomMeetingController extends ChangeNotifier {


  Future<void> zoomPost( String date,String time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    final response = await http.post(Uri.parse("$baseUrl/zoom_Records"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (cookies != null) 'Cookie': cookies,
        },
        body: jsonEncode({
          "zoom_date": date,
          "zoom_time": time
        }));
    // var decode = jsonDecode(response.body);
    // print(decode.toString());
    try {
      if (response.statusCode == 200) {
      } else {
      }
    } catch (e) {
      print("requestPasswordReset : $e");
    }
  }
}