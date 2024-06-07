import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';
import 'package:http/http.dart' as http;

import '../models/zoom_class_model.dart';

class ZoomMeetingController extends ChangeNotifier {


  Future<void> zoomPost(String date, String time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    final response = await http.post(Uri.parse("$baseUrl/zoom_Records"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (cookies != null) 'Cookie': cookies,
        },
        body: jsonEncode({"zoom_date": date, "zoom_time": time}));
    // var decode = jsonDecode(response.body);
    // print(decode.toString());
    try {
      if (response.statusCode == 200) {
      } else {}
    } catch (e) {
      print("requestPasswordReset : $e");
    }
  }

  ZoomClassModel _ZoomClassModelData = ZoomClassModel() ;

  ZoomClassModel get ZoomClassModelData => _ZoomClassModelData;

  Future<void> zoomClass() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cookies = prefs.getString("cookie");
    var date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final response = await http.get(
      Uri.parse("$baseUrl/get-zoomclass?currentDate=$date"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        if (cookies != null) 'Cookie': cookies,
      },
    );
    var decode = jsonDecode(response.body);

    try {
      if (response.statusCode == 200) {
        _ZoomClassModelData = ZoomClassModel.fromJson(decode[0]);
        // print(_ZoomClassModelData.zoomLink);
      } else {

        print(decode);
      }
    } catch (e) {
      print("requestPasswordReset : $e");
    }
  }
}
