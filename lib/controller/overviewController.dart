import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../constant/constant.dart';
import '../models/overview_carosalslider.dart';


class OverViewController extends ChangeNotifier {


  List<EventData> get eventLIst => _eventLIst;
  List<EventData> _eventLIst = [];

  Future<void> eventList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var cookies = prefs.getString("cookie");
      final response = await http.get(Uri.parse("$baseUrl/listevents"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (cookies != null) 'Cookie': cookies,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> dataList = jsonDecode(response.body);
        List<dynamic> data = dataList["events"];
        _eventLIst = List<EventData>.from(data.map((x) => EventData.fromJson(x)));
      } else {
        // Handle other status codes if needed
        print("Failed to load eventLIst: ${response.statusCode}");
      }
    } catch (e) {
      print("Error to load eventLIst: $e");
    }
    notifyListeners();
  }
}
